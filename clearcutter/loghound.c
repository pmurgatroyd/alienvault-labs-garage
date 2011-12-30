/*
LogHound version 0.01 - loghound
a tool for mining frequent patterns from event logs

Copyright (C) 2004 Risto Vaarandi

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*/

#include <sys/types.h> /* for system typedefs, e.g., time_t */
#include <stdio.h>     /* for fopen(), fread(), etc. */
#include <regex.h>     /* for regcomp() and regexec() */
#include <string.h>    /* for strcmp(), strcpy(), etc. */
#include <stdlib.h>    /* for malloc(), atoi/f(), rand(), and getopt() */
#include <unistd.h>    /* for getopt() on some platforms, e.g., Linux */
#include <time.h>      /* for time() and ctime() */

/* Constants */

#define MAXLINELEN 10240  /* maximum length of a line */
#define MAXWORDLEN 10244  /* maximum length of a word, should be
                             at least MAXLINELEN+4 */
#define MAXWORDS 512      /* maximum number of words in one line
                             (defined value must not exceed 2^16-1) */
#define MAXKEYLEN 2048    /* maximum hash key length for sequence vector */
#define MAXLOGMSGLEN 256  /* maximum log message length */
#define BACKREFCHAR '$'   /* character that starts backreference variables */
#define MAXPARANEXPR 100  /* maximum number of () expressions in regexp */
#define BINSEARCHSIZE 20

#define NODE_LOCKED  1
#define NODE_INCOMPL 2
#define NODE_APRIORI 4

const char num2str[16] = { '0', '1', '2', '3', '4', '5', '6', '7',
                           '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

/* Type definitions */

typedef unsigned long support_t;
typedef unsigned long wordnumber_t;
typedef unsigned long tableindex_t;

struct elem {
  char *key;
  support_t count;
  wordnumber_t number;
  struct elem *next;
};

struct inputfile {
  char *name;
  struct inputfile *next;
};

struct templelem {
  char *str;
  int data;
  struct templelem *next;
};

struct co_occur {
  wordnumber_t number;
  wordnumber_t co_occur;
};

struct link {
  wordnumber_t number;
  struct node *node;
};

struct node {
  support_t support;
  wordnumber_t childcount;
  struct link *children;
  char flags;
};

struct pattern {
  wordnumber_t *numbers;
  int wordcount;
  struct pattern *next;
};

struct patgroup {
  support_t support;
  struct pattern *patterns;
  struct patgroup *left;
  struct patgroup *right;
};

/* Global variables */

char *DELIM, *FILTER;
regex_t DELIM_REGEX, FILTER_REGEX;

support_t SUPPORT;
double PCTSUPPORT;

int BYTEOFFSET;
char CLOSED;
int LENGTH;
int PREFIX;

struct inputfile *INPUTFILES;

unsigned int INITSEED;

support_t CACHESUPPORT;
char *OUTOFCACHEFILE;

support_t *WORDVECTOR;
tableindex_t WORDVECTORSIZE;
tableindex_t WORDVECTORSEED;

support_t *CACHEVECTOR;
tableindex_t CACHEVECTORSIZE;
tableindex_t CACHEVECTORSEED;

struct elem **WORDTABLE;
tableindex_t WORDTABLESIZE;
tableindex_t WORDTABLESEED;

struct templelem *TEMPLATE;

struct elem **WORDNUMBERS;
wordnumber_t WORDNUM;

char WORDNUMBYTES;

wordnumber_t *CONVTABLE;

wordnumber_t **WORDMATRIX;
wordnumber_t *ROWLENGTH;

struct node *PATTREE;
support_t PATNODES;

struct node *DATATREE;
support_t DATANODES;

struct patgroup *PATGROUPS;

char *MASK;
char *PATH;
wordnumber_t NUMBERS[MAXWORDS];

/* Logging functions */

void log_msg(char *message)
{
  time_t t;
  char *timestamp;

  t = time(0);
  timestamp = ctime(&t);
  timestamp[strlen(timestamp) - 1] = 0;
  fprintf(stderr, "%s: %s\n", timestamp, message);
}

/* Hashing functions */

tableindex_t str2hash(char *string, tableindex_t mod, tableindex_t h)
{
  int i;

  /* fast hashing algorithm by M.V.Ramakrishna and Justin Zobel */
  for (i = 0; string[i] != 0; ++i) {
    h = h ^ ((h << 5) + (h >> 2) + string[i]);
  }

  return h % mod;
}


tableindex_t num2hash(char *num, int size, tableindex_t mod, tableindex_t h)
{
  int i;

  /* fast hashing algorithm by M.V.Ramakrishna and Justin Zobel */
  for (i = 0; i < size; ++i) {
    h = h ^ ((h << 5) + (h >> 2) + num[i]);
  }

  return h % mod;
}

/* Hash table functions */

struct elem *add_elem(char *key, struct elem **table, 
                      tableindex_t tablesize, tableindex_t seed)
{
  tableindex_t hash;
  struct elem *ptr, *prev;
  
  hash = str2hash(key, tablesize, seed);

  if (table[hash]) {

    prev = 0;
    ptr = table[hash];
                      
    while (ptr) { 
      if (!strcmp(key, ptr->key))  { break; } 
      prev = ptr;
      ptr = ptr->next;
    }

    if (ptr) {
        
      ++ptr->count; 

      if (prev) {
        prev->next = ptr->next;
        ptr->next = table[hash];
        table[hash] = ptr;
      }
          
    } else {
        
      ptr = (struct elem *) malloc(sizeof(struct elem));
      
      ptr->key = (char *) malloc(strlen(key) + 1);
      
      strcpy(ptr->key, key);
      ptr->count = 1;
      ptr->next = table[hash];
      table[hash] = ptr;
          
    }
                  
  } else {
             
    ptr = (struct elem *) malloc(sizeof(struct elem));
    
    ptr->key = (char *) malloc(strlen(key) + 1);
    
    strcpy(ptr->key, key);
    ptr->count = 1;
    ptr->next = 0;
    table[hash] = ptr;
            
  }
  
  return ptr;
}


struct elem *find_elem(char *key, struct elem **table, 
                       tableindex_t tablesize, tableindex_t seed)
{
  tableindex_t hash;
  struct elem *ptr, *prev;
  
  prev = 0;
  hash = str2hash(key, tablesize, seed);

  for (ptr = table[hash]; ptr; ptr = ptr->next) {
    if (!strcmp(key, ptr->key))  { break; } 
    prev = ptr;
  }

  if (ptr && prev) {
    prev->next = ptr->next;
    ptr->next = table[hash];
    table[hash] = ptr;
  }
  
  return ptr;
}


void free_table(struct elem **table, tableindex_t tablesize)
{
  tableindex_t i;
  struct elem *ptr, *next;

  for (i = 0; i < tablesize; ++i) {

    if (!table[i])  { continue; }

    ptr = table[i];

    while (ptr) {

      next = ptr->next;
                
      free((void *) ptr->key);
      free((void *) ptr);

      ptr = next;
      
    }

  }
  
  free((void *) table);
}

/* Line processing functions */

int find_words(char *line, char (*words)[MAXWORDLEN])
{
  regmatch_t match[MAXPARANEXPR];
  int i, j, linelen, len;
  struct templelem *ptr;
  char *buffer;
  
  if (*line == 0)  { return 0; }
  
  linelen = strlen(line);

  if (BYTEOFFSET >= linelen)  { return 0; }

  if (BYTEOFFSET) {
    line += BYTEOFFSET;
    linelen -= BYTEOFFSET;
  }
  
  if (FILTER) {
 
    if (regexec(&FILTER_REGEX, line, MAXPARANEXPR, match, 0))  { return 0; }
    
    if (TEMPLATE) {
    
      len = 0;
      
      for (ptr = TEMPLATE; ptr; ptr = ptr->next) {
        if (ptr->str) {
          len += ptr->data;
        } else if (!ptr->data) {
          len += linelen;
        } else if (match[ptr->data].rm_so != -1  &&
                   match[ptr->data].rm_eo != -1) {
          len += match[ptr->data].rm_eo - match[ptr->data].rm_so;
        }
      }
      
      i = 0;
      buffer = (char *) malloc(len + 1);
        
      for (ptr = TEMPLATE; ptr; ptr = ptr->next) {

        if (ptr->str) {
          strncpy(buffer + i, ptr->str, ptr->data);
          i += ptr->data;
        } else if (!ptr->data) {
          strncpy(buffer + i, line, linelen);
          i += linelen;
        } else if (match[ptr->data].rm_so != -1  &&
                   match[ptr->data].rm_eo != -1) {
          len = match[ptr->data].rm_eo - match[ptr->data].rm_so;
          strncpy(buffer + i, line + match[ptr->data].rm_so, len);
          i += len;
        }

      }
      
      buffer[i] = 0;
      line = buffer;

    }
    
  }
    
  for (i = 0; i < MAXWORDS; ++i) {

    if (regexec(&DELIM_REGEX, line, 1, match, 0)) {

      if (PREFIX) {
      
        words[i][0] = num2str[((i + 1) >> 12) & 0xF];
        words[i][1] = num2str[((i + 1) >> 8) & 0xF];
        words[i][2] = num2str[((i + 1) >> 4) & 0xF];
        words[i][3] = num2str[(i + 1) & 0xF];
        
      }
      
      for (j = 0; line[j] != 0; ++j)  { words[i][j+PREFIX] = line[j]; }
      words[i][j+PREFIX] = 0;

      break; 

    }

    if (PREFIX) {
    
      words[i][0] = num2str[((i + 1) >> 12) & 0xF];
      words[i][1] = num2str[((i + 1) >> 8) & 0xF];
      words[i][2] = num2str[((i + 1) >> 4) & 0xF];
      words[i][3] = num2str[(i + 1) & 0xF];
    
    }
    
    for (j = 0; j < match[0].rm_so; ++j)  { words[i][j+PREFIX] = line[j]; }
    words[i][j+PREFIX] = 0;

    line += match[0].rm_eo;

    if (*line == 0)  { break; }

  }

  if (TEMPLATE)  { free((void *) buffer); }
  
  if (i == MAXWORDS) { return i; }  else { return i+1; }
}

/* Word processing functions */

tableindex_t create_word_vector(void)
{
  FILE *file;
  struct inputfile *fileptr;
  char line[MAXLINELEN];
  char words[MAXWORDS][MAXWORDLEN];
  int len, i, wordcount;
  tableindex_t hash, j, oversupport;
  char logstr[MAXLOGMSGLEN];
  support_t linecount;

  linecount = 0;
    
  for (j = 0; j < WORDVECTORSIZE; ++j)  { WORDVECTOR[j] = 0; }

  for (fileptr = INPUTFILES; fileptr; fileptr = fileptr->next) {
  
    if (!(file = fopen(fileptr->name, "r"))) {
      sprintf(logstr, "Can't open inputfile %s", fileptr->name);
      log_msg(logstr);
      continue;
    }

    while (fgets(line, MAXLINELEN, file)) {

      len = strlen(line);
      if (line[len-1] == '\n')  { line[len-1] = 0; }

      wordcount = find_words(line, words);

      for (i = 0; i < wordcount; ++i)  { 

        if (words[i][PREFIX] == 0)  { continue; }
        hash = str2hash(words[i], WORDVECTORSIZE, WORDVECTORSEED);
        ++WORDVECTOR[hash];
                  
      }
    
      ++linecount;

    }

    fclose(file);
    
  }

  if (!SUPPORT)  { SUPPORT = linecount * PCTSUPPORT / 100; }
  
  oversupport = 0;
  
  for (j = 0; j < WORDVECTORSIZE; ++j) { 
    if (WORDVECTOR[j] >= SUPPORT)  { ++oversupport; }
  }

  return oversupport;
}


wordnumber_t create_vocabulary(void)
{
  FILE *file;
  struct inputfile *fileptr;
  char line[MAXLINELEN];
  char words[MAXWORDS][MAXWORDLEN];
  int len, i, wordcount;
  tableindex_t hash, j;
  char logstr[MAXLOGMSGLEN];
  struct elem *word;
  support_t linecount;
  wordnumber_t number;

  number = 0;  
  linecount = 0;
    
  for (j = 0; j < WORDTABLESIZE; ++j)  { WORDTABLE[j] = 0; }
  
  for (fileptr = INPUTFILES; fileptr; fileptr = fileptr->next) {
  
    if (!(file = fopen(fileptr->name, "r"))) {
      sprintf(logstr, "Can't open inputfile %s", fileptr->name);
      log_msg(logstr);
      continue;
    }
  
    while (fgets(line, MAXLINELEN, file)) {

      len = strlen(line);
      if (line[len-1] == '\n')  { line[len-1] = 0; }

      wordcount = find_words(line, words);

      for (i = 0; i < wordcount; ++i)  { 

        if (words[i][PREFIX] == 0)  { continue; }

        if (WORDVECTORSIZE) {
          hash = str2hash(words[i], WORDVECTORSIZE, WORDVECTORSEED);
          if (WORDVECTOR[hash] < SUPPORT)  { continue; }      
        }
      
        word = add_elem(words[i], WORDTABLE, WORDTABLESIZE, WORDTABLESEED);

        if (word->count == 1)  { ++number; }

      }
    
      ++linecount;

    }

    fclose(file);
    
  }
  
  if (!SUPPORT)  { SUPPORT = linecount * PCTSUPPORT / 100; }

  return number;
}


wordnumber_t find_frequent_words(void)
{
  tableindex_t i;
  wordnumber_t number;
  struct elem *ptr, *prev, *next;

  number = 0;

  for (i = 0; i < WORDTABLESIZE; ++i) {

    if (!WORDTABLE[i])  { continue; }

    prev = 0;
    ptr = WORDTABLE[i];

    while (ptr) {

      if (ptr->count < SUPPORT) {

        if (prev) { 
          prev->next = ptr->next; 
        } else { 
          WORDTABLE[i] = ptr->next; 
        }

        next = ptr->next;
                
        free((void *) ptr->key);
        free((void *) ptr);

        ptr = next;
        
      } else {

        ptr->number = number++;
        prev = ptr;
        ptr = ptr->next;
                        
      }
       
    }
    
  }

  for (i = 0; i < WORDTABLESIZE; ++i) {
    
    for (ptr = WORDTABLE[i]; ptr; ptr = ptr->next) {
      WORDNUMBERS[ptr->number] = ptr;
    }
                  
  }
                      
  return number;
}

/* Element comparison functions */

int co_occur_compare(const void *p1, const void *p2)
{
  wordnumber_t i, j;
  support_t x, y;
  
  i = ((struct co_occur *) p1)->co_occur;
  j = ((struct co_occur *) p2)->co_occur;
  
  if (i > j) { return 1; }
  if (i < j) { return -1; }
  
  x = WORDNUMBERS[((struct co_occur *) p1)->number]->count;
  y = WORDNUMBERS[((struct co_occur *) p2)->number]->count;
  
  if (x > y) { return 1; }
  if (x < y) { return -1; }
  
  return 0;
}


int wordnumber_compare(const void *p1, const void *p2)
{
  wordnumber_t i, j;
  
  i = *((wordnumber_t *) p1);
  j = *((wordnumber_t *) p2);
  
  if (i > j) { return 1; }
  if (i < j) { return -1; }
  
  return 0;
}


int word_compare(const void *p1, const void *p2)
{
  wordnumber_t i, j;
  
  i = *((wordnumber_t *) p1);
  j = *((wordnumber_t *) p2);

  return strncmp(WORDNUMBERS[i]->key, WORDNUMBERS[j]->key, PREFIX);
}

/* Functions for creation of mining data structures */

void create_mining_data_struct(void)
{
  FILE *file;
  struct inputfile *fileptr;
  char line[MAXLINELEN];
  char key[MAXKEYLEN];
  char words[MAXWORDS][MAXWORDLEN];
  wordnumber_t numbers[MAXWORDS];
  int byte, i, j, len, wordcount;
  struct elem **wordnumbers;
  struct elem *word;
  wordnumber_t k, l, m, new;
  wordnumber_t **matrix;
  wordnumber_t *rowlength, *row, *ptr;
  struct co_occur *sorted;
  char logstr[MAXLOGMSGLEN];
  tableindex_t hash;
  char *mask, match;

  for (hash = 0; hash < CACHEVECTORSIZE; ++hash)  { CACHEVECTOR[hash] = 0; }

  matrix = (wordnumber_t **) malloc(sizeof(wordnumber_t *) * WORDNUM);
  rowlength = (wordnumber_t *) malloc(sizeof(wordnumber_t) * WORDNUM);
  mask = (char *) malloc(sizeof(char) * WORDNUM);
    
  for (k = 0; k < WORDNUM; ++k) { 
    matrix[k] = 0; 
    rowlength[k] = 0;  
    mask[k] = 0;
  }

  for (fileptr = INPUTFILES; fileptr; fileptr = fileptr->next) {
  
    if (!(file = fopen(fileptr->name, "r"))) {
      sprintf(logstr, "Can't open inputfile %s", fileptr->name);
      log_msg(logstr);
      continue;
    }
   
    while (fgets(line, MAXLINELEN, file)) {

      len = strlen(line);
      if (line[len-1] == '\n')  { line[len-1] = 0; }

      wordcount = find_words(line, words);

      j = 0;
            
      for (i = 0; i < wordcount; ++i) { 

        word = find_elem(words[i], WORDTABLE, WORDTABLESIZE, WORDTABLESEED);

        if (words[i][PREFIX] != 0  &&  word) { 
        
          if (CACHEVECTORSIZE) {
          
            len = j * WORDNUMBYTES;
            k = word->number;
            
            for (byte = 0; byte < WORDNUMBYTES; ++byte) {
              key[len+byte] = k & 255;
              k >>= 8;
            }
            
          }
                                        
          numbers[j++] = word->number;
          
        }
        
      }

      if (!j)  { continue; }

      wordcount = j;

      if (CACHEVECTORSIZE) {
      
        len = WORDNUMBYTES * wordcount;
        hash = num2hash(key, len, CACHEVECTORSIZE, CACHEVECTORSEED);
        ++CACHEVECTOR[hash];
        
      }

      for (i = 0; i < wordcount; ++i)  { mask[numbers[i]] = 1; }
                 
      for (i = 0; i < wordcount; ++i) {

        k = numbers[i];
              
        if (rowlength[k]) {
          
          new = rowlength[k];
            
          for (l = 0; l < rowlength[k]; ++l) {
            
            if (!mask[matrix[k][l]]) {
              matrix[k][l] = WORDNUM;
              --new;  
            }
              
          }
        
          if (new == rowlength[k])  { continue; }
              
          ptr = (wordnumber_t *) 
                malloc(sizeof(wordnumber_t) * new);
              
          m = 0;
             
          for (l = 0; l < rowlength[k]; ++l) {
            if (matrix[k][l] != WORDNUM)  { ptr[m++] = matrix[k][l]; }
          } 
              
          free((void *) matrix[k]);
 
          matrix[k] = ptr;
          rowlength[k] = new;

        } else {
          
          rowlength[k] = wordcount;
          matrix[k] = (wordnumber_t *)
                      malloc(sizeof(wordnumber_t) * wordcount);

          for (l = 0; l < rowlength[k]; ++l)  { matrix[k][l] = numbers[l]; } 
          
        }
                  
      }

      for (i = 0; i < wordcount; ++i)  { mask[numbers[i]] = 0; }

    }      

    fclose(file);
    
  }

  sorted = (struct co_occur *) malloc(sizeof(struct co_occur) * WORDNUM);
  
  for (k = 0; k < WORDNUM; ++k) {
  
    sorted[k].number = k;
    sorted[k].co_occur = rowlength[k];
    
  }

  qsort((void *) sorted, (size_t) WORDNUM, 
        sizeof(struct co_occur), co_occur_compare);

  wordnumbers = (struct elem **) malloc(sizeof(struct elem *) * WORDNUM);  
  row = (wordnumber_t *) malloc(sizeof(wordnumber_t) * WORDNUM);  
  
  for (k = 0; k < WORDNUM; ++k)  { CONVTABLE[sorted[k].number] = k; }

  for (k = 0; k < WORDNUM; ++k) {

    new = CONVTABLE[k];
    ROWLENGTH[new] = 0;

    for (l = 0; l < rowlength[k]; ++l) {

      if (CONVTABLE[matrix[k][l]] < new) { 

        row[ROWLENGTH[new]] = CONVTABLE[matrix[k][l]];
        ++ROWLENGTH[new];
        
      }
          
    }  

    if (matrix[k])  { free((void *) matrix[k]); }
    
    if (ROWLENGTH[new]) {
    
      WORDMATRIX[new] = (wordnumber_t *) 
                        malloc(sizeof(wordnumber_t) * ROWLENGTH[new]);
    
      for (l = 0; l < ROWLENGTH[new]; ++l) { WORDMATRIX[new][l] = row[l]; }
      
    }
    
    wordnumbers[new] = WORDNUMBERS[k];
    
  }

  free((void *) matrix);
  free((void *) rowlength);
  free((void *) mask);

  free((void *) sorted);
  free((void *) row);

  free((void *) WORDNUMBERS);
  WORDNUMBERS = wordnumbers;
        
}

/* Functions for searching the node link table */

char search_pos(struct link *children, wordnumber_t childcount, 
                wordnumber_t number, wordnumber_t *pos) {
  wordnumber_t i, j;
  wordnumber_t middle, size;

  if (*pos >= childcount  ||  number < children[*pos].number) { 
    return 0; 
  }
  
  if (number > children[childcount-1].number) { 
    *pos = childcount;
    return 0; 
  }
 
  i = *pos;
  j = childcount - 1;
  
  for (;;) {
  
    size = j - i + 1;
    
    if (size == 2) {
    
      if (number == children[i].number) { 
        *pos = i;
        return 1;
      } 
      
      if (number < children[j].number) { 
        *pos = j;
        return 0;
      } 
      
      *pos = j;
      return 1; 
    
    }
    
    middle = i + (size >> 1);

    if (number == children[middle].number) { 
      *pos = middle;
      return 1; 
    }
    
    if (number < children[middle].number)  { j = middle; }
    if (number > children[middle].number)  { i = middle; }
    
  }
  
}

/* Transaction (data) tree functions */

void add_to_data_tree(wordnumber_t *numbers, int wordcount) {
  struct node *node;
  struct link *ptr;
  wordnumber_t pos, k;
  char match;
  int i;

  node = DATATREE;
        
  for (i = 0; i < wordcount; ++i) { 

    pos = 0;

    match = search_pos(node->children, node->childcount, numbers[i], &pos); 

    if (!match) {

      ++node->childcount;
      
      ptr = (struct link *) malloc(sizeof(struct link) * node->childcount);
      
      for (k = 0; k < pos; ++k) { 
        ptr[k].number = node->children[k].number;
        ptr[k].node = node->children[k].node;
      }
      
      ptr[pos].number = numbers[i];
      ptr[pos].node = (struct node *) malloc(sizeof(struct node));
          
      ptr[pos].node->support = 0;
      ptr[pos].node->childcount = 0;
      ptr[pos].node->children = 0;
          
      for (k = pos+1; k < node->childcount; ++k) { 
        ptr[k].number = node->children[k-1].number;
        ptr[k].node = node->children[k-1].node;
      }

      if (node->children) { free((void *) node->children); }
      node->children = ptr;

      ++DATANODES;
      
    }

    node = node->children[pos].node;
    
  }
  
  ++node->support;
                  
}


support_t create_data_tree(void)
{
  FILE *file, *file2;
  struct inputfile *fileptr;
  char line[MAXLINELEN];
  char key[MAXKEYLEN];
  char words[MAXWORDS][MAXWORDLEN];
  wordnumber_t numbers[MAXWORDS];
  int byte, i, j, len, wordcount;
  struct elem *word;
  char logstr[MAXLOGMSGLEN];
  wordnumber_t k;
  tableindex_t hash;
  support_t linesinmem;
  
  linesinmem = 0;
    
  DATATREE = (struct node *) malloc(sizeof(struct node));
  DATATREE->support = 0;
  DATATREE->childcount = 0;
  DATATREE->children = 0;

  ++DATANODES;
  
  if (OUTOFCACHEFILE  &&  !(file2 = fopen(OUTOFCACHEFILE, "w"))) {
    sprintf(logstr, "Can't open out-of-cache file %s", OUTOFCACHEFILE);
    log_msg(logstr);
    exit(1);
  }
    
  for (fileptr = INPUTFILES; fileptr; fileptr = fileptr->next) {
  
    if (!(file = fopen(fileptr->name, "r"))) {
      sprintf(logstr, "Can't open inputfile %s", fileptr->name);
      log_msg(logstr);
      continue;
    }
   
    while (fgets(line, MAXLINELEN, file)) {

      len = strlen(line);
      if (line[len-1] == '\n')  { line[len-1] = 0; }

      wordcount = find_words(line, words);

      j = 0;
            
      for (i = 0; i < wordcount; ++i) { 

        word = find_elem(words[i], WORDTABLE, WORDTABLESIZE, WORDTABLESEED);
      
        if (words[i][PREFIX] != 0  &&  word) { 

          if (CACHEVECTORSIZE) {
          
            len = j * WORDNUMBYTES;
            k = word->number;
            
            for (byte = 0; byte < WORDNUMBYTES; ++byte) {
              key[len+byte] = k & 255;
              k >>= 8;
            }
            
          }
                                        
          numbers[j++] = CONVTABLE[word->number];

        }
        
      }

      if (!j) { continue; }
      
      wordcount = j;

      qsort((void *) numbers, (size_t) wordcount,
            sizeof(wordnumber_t), wordnumber_compare);

      if (CACHEVECTORSIZE) {

        len = WORDNUMBYTES * wordcount;
        hash = num2hash(key, len, CACHEVECTORSIZE, CACHEVECTORSEED);

        if (CACHEVECTOR[hash] < CACHESUPPORT) { 

          *line = 0;
          
          for (i = 0; i < wordcount; ++i) {
            sprintf(key, "%llu ", (unsigned long long) numbers[i]);
            strcat(line, key);
          }
          
          len = strlen(line);
          line[len-1] = '\n';
          
          fputs(line, file2);
          continue; 

        }

      }

      add_to_data_tree(numbers, wordcount);

      ++linesinmem;
            
    }      

    fclose(file);
    
  }

  if (OUTOFCACHEFILE)  { fclose(file2); }

  return linesinmem;
    
}

/* Pattern tree functions */

void create_first_level(void)
{
  wordnumber_t pos, k, l;
  struct link *ptr;
  
  PATTREE = (struct node *) malloc(sizeof(struct node));
  PATTREE->support = 0;
  PATTREE->childcount = 0;
  PATTREE->children = 0;
  PATTREE->flags = 0;

  ++PATNODES;
    
  for (k = 0; k < WORDNUM; ++k) {

    if (!ROWLENGTH[k]) {

      pos = PATTREE->childcount;
      ++PATTREE->childcount;
      ptr = (struct link *) malloc(sizeof(struct link) * PATTREE->childcount);

      for (l = 0; l < pos; ++l) {  
        ptr[l].number = PATTREE->children[l].number;
        ptr[l].node = PATTREE->children[l].node;
      }

      ptr[pos].number = k;
      ptr[pos].node = (struct node *) malloc(sizeof(struct node));
      
      ptr[pos].node->support = WORDNUMBERS[k]->count;
      ptr[pos].node->childcount = 0;
      ptr[pos].node->children = 0;
      ptr[pos].node->flags = 0;
                                 
      if (PATTREE->children) { free((void *) PATTREE->children); }
      PATTREE->children = ptr;

      ++PATNODES;
            
    } else { PATTREE->flags |= NODE_INCOMPL; }
    
  }
  
}


void gen_candidates(struct node *node, struct node *parent, int level)
{
  wordnumber_t k, m;
  
  --level;  

  if (level) {

    if (!node->childcount)  { return; }
      
    for (k = 0; k < node->childcount; ++k) {
      gen_candidates(node->children[k].node, node, level);
    }

  } else {
  
    if (parent->flags & NODE_INCOMPL)  { return; }

    for (k = 0; k < parent->childcount; ++k) {
      if (parent->children[k].node == node)  { break; }
    }
    
    m = 0;
    ++k;

    if (k < parent->childcount) {
   
      node->childcount = parent->childcount - k;    
      node->children = (struct link *)
                       malloc(sizeof(struct link) * node->childcount);
      node->flags = NODE_APRIORI;
                       
    }
                         
    while (k < parent->childcount) {

      node->children[m].number = parent->children[k].number;
      node->children[m].node = (struct node *) malloc(sizeof(struct node));

      node->children[m].node->support = 0;
      node->children[m].node->childcount = 0;
      node->children[m].node->children = 0;
      node->children[m].node->flags = 0;
      
      ++k;
      ++m;
      
      ++PATNODES;
    
    }

  }
                
}


void add_to_pat_tree(int start, int wordcount, struct node *node, 
                     int level, support_t support) {
  wordnumber_t pos, k;
  struct link *ptr;
  char match;
  int i;

  --level;

  if (level) {

    if (NUMBERS[start] > node->children[node->childcount-1].number ||
        NUMBERS[wordcount-1] < node->children[0].number)  { return; }
        
    pos = 0;
   
    for (i = start; i < wordcount; ++i) { 

      if (wordcount - i <= level)  { return; }

      if (node->childcount - pos < BINSEARCHSIZE) {
    
        match = 0;
      
        while (pos < node->childcount) {

          if (node->children[pos].number == NUMBERS[i]) { match = 1; break; }
          if (node->children[pos].number > NUMBERS[i])  { break; }
          ++pos;
        
        }
    
      } else {
    
        match = search_pos(node->children, node->childcount, NUMBERS[i], &pos); 
      
      } 

      if (match) {

        if (node->children[pos].node->flags & NODE_LOCKED)  { continue; }
        
        PATH[NUMBERS[i]] = 1;

        add_to_pat_tree(i+1, wordcount, node->children[pos].node, 
                        level, support);

        PATH[NUMBERS[i]] = 0;
        
        ++pos;
        
      } else {

        if (NUMBERS[i] > node->children[node->childcount-1].number) { 
          return; 
        }
      
      }
    
    }

  } else {

    pos = 0;
    
    for (i = start; i < wordcount; ++i) { 

      if (node->childcount - pos < BINSEARCHSIZE) {
    
        match = 0;
      
        while (pos < node->childcount) {

          if (node->children[pos].number == NUMBERS[i]) { match = 1; break; }
          if (node->children[pos].number > NUMBERS[i])  { break; }
          ++pos;
        
        }
    
      } else {
    
        match = search_pos(node->children, node->childcount, NUMBERS[i], &pos); 
      
      } 
  
      if (!match) {

        if (node->flags & NODE_APRIORI)  { continue; }
        
        for (k = 0; k < ROWLENGTH[NUMBERS[i]]; ++k) {
          if (!PATH[WORDMATRIX[NUMBERS[i]][k]])  { break; } 
        }    

        if (k != ROWLENGTH[NUMBERS[i]]) { 
          node->flags |= NODE_INCOMPL;
          continue; 
        }

        ++node->childcount;

        ptr = (struct link *) malloc(sizeof(struct link) * node->childcount);
                
        for (k = 0; k < pos; ++k) {
          ptr[k].number = node->children[k].number;
          ptr[k].node = node->children[k].node;
        }
                              
        ptr[pos].number = NUMBERS[i];
        ptr[pos].node = (struct node *) malloc(sizeof(struct node));
                                          
        ptr[pos].node->support = support;

        ptr[pos].node->childcount = 0;
        ptr[pos].node->children = 0;
       
        ptr[pos].node->flags = 0;
        
        for (k = pos+1; k < node->childcount; ++k) {
          ptr[k].number = node->children[k-1].number;
          ptr[k].node = node->children[k-1].node;
        }
                             
        if (node->children) { free((void *) node->children); }
        node->children = ptr;
       
        ++pos;

	++PATNODES;

      } else {
      
        node->children[pos].node->support += support;
        ++pos;
        
      }
      
    }

  }
  
}


void create_next_level(int level, struct node *node, int pos)
{
  wordnumber_t k;

  for (k = 0; k < node->childcount; ++k) {

    if (!node->children[k].node->childcount) {

      NUMBERS[pos] = node->children[k].number;

      add_to_pat_tree(0, pos+1, PATTREE, level, 
                      node->children[k].node->support);

    } else { 

      NUMBERS[pos] = node->children[k].number;

      if (node->children[k].node->support) {  

        add_to_pat_tree(0, pos+1, PATTREE, level, 
                        node->children[k].node->support);
                        
      }

      create_next_level(level, node->children[k].node, pos+1);
                        
    }

  }

}


void create_next_level2(int level)
{
  FILE *file;
  struct inputfile *fileptr;
  char line[MAXLINELEN];
  wordnumber_t numbers[MAXWORDS];
  char logstr[MAXLOGMSGLEN];
  char *ptr, *endptr;
  int wordcount;
  wordnumber_t k;
  
  if (!(file = fopen(OUTOFCACHEFILE, "r"))) {
    sprintf(logstr, "Can't open out-of-cache file %s", OUTOFCACHEFILE);
    log_msg(logstr);
    exit(1);
  }

  while (fgets(line, MAXLINELEN, file)) {

    ptr = line;
    wordcount = 0;

    for (;;) {

      k = (wordnumber_t) strtoll(ptr, &endptr, 10);
      if (endptr == ptr)  { break; }
      NUMBERS[wordcount++] = k;
      ptr = endptr;
      if (!*ptr)  { break; }
      ++ptr;
      
    }
    
    add_to_pat_tree(0, wordcount, PATTREE, level, 1);
      
  }      

  fclose(file);

}


wordnumber_t prune_leaves(struct node *node, int level)
{
  wordnumber_t k, l, freecount, removed, left;
  struct link *ptr;

  --level;  
  freecount = node->childcount;
  removed = 0;
  
  for (k = 0; k < node->childcount; ++k) {

    if (!node->children[k].node->childcount) {
    
      if (level) {

        node->children[k].node->flags |= NODE_LOCKED;
        --freecount;

      }
      
      if (node->children[k].node->support < SUPPORT) {

        free((void *) node->children[k].node);
        node->children[k].node = 0;
        ++removed;
        --freecount;

      }
                
    } else { 
    
      if (!prune_leaves(node->children[k].node, level)) { --freecount; }
      
    }

  }

  if (removed) {
  
    PATNODES -= removed;
    left = node->childcount - removed;
    
    if (left) {
    
      ptr = (struct link *) malloc(sizeof(struct link) * left);

      l = 0;
    
      for (k = 0; k < node->childcount; ++k) {

        if (!node->children[k].node)  { continue; }
      
        ptr[l].number = node->children[k].number;
        ptr[l].node = node->children[k].node;

        ++l;
        
      }
            
    } else { ptr = 0; }

    free((void *) node->children);
    node->children = ptr;
    node->childcount = left;
      
  }
  
  if (!freecount)  { node->flags |= NODE_LOCKED; }
  
  return freecount;
  
}

/* Functions for reporting frequent patterns */

wordnumber_t print_pattern(support_t support, int wordcount)
{
  wordnumber_t numbers2[MAXWORDS];
  wordnumber_t l, m;
  char number[5];
  int i, j, k;
    
  m = 0;
  
  for (i = 0; i < wordcount; ++i) {

    for (l = 0; l < ROWLENGTH[NUMBERS[i]]; ++l) {

      if (!MASK[WORDMATRIX[NUMBERS[i]][l]]) {
        MASK[WORDMATRIX[NUMBERS[i]][l]] = 1;
        ++m;
      }
      
    }
    
    numbers2[i] = NUMBERS[i];
    
  }

  if (PREFIX) {
  
    qsort((void *) numbers2, (size_t) wordcount,
          sizeof(wordnumber_t), word_compare);
  
    j = 1;
  
    for (i = 0; i < wordcount; ++i) {

      strncpy(number, WORDNUMBERS[numbers2[i]]->key, PREFIX);
      number[PREFIX] = 0;

      k = (int) strtol(number, 0, 16);
      while (j < k) { printf("* "); ++j; }
      j = k + 1;
    
      if (MASK[numbers2[i]]) {
        printf("(%s) ", WORDNUMBERS[numbers2[i]]->key+PREFIX);
        MASK[numbers2[i]] = 0;
      } else {
        printf("%s ", WORDNUMBERS[numbers2[i]]->key+PREFIX);
      }
      
    }
      
  } else {
  
    for (i = 0; i < wordcount; ++i) {

      if (MASK[NUMBERS[i]]) {
        printf("(%s) ", WORDNUMBERS[NUMBERS[i]]->key);
        MASK[NUMBERS[i]] = 0;
      } else {
        printf("%s ", WORDNUMBERS[NUMBERS[i]]->key);
      }
    
    }
  
  }  

  printf("\nSupport: %llu\n\n", (unsigned long long) support);
    
  return m;
}


unsigned long long find_patterns(struct node *node, int wordcount)
{
  wordnumber_t k, count;
  unsigned long long n;
  
  n = 0;
  
  for (k = 0; k < node->childcount; ++k) {

    NUMBERS[wordcount] = node->children[k].number;
    
    count = print_pattern(node->children[k].node->support, wordcount+1);
                          
    n += (((unsigned long long) 1) << count);
    n += find_patterns(node->children[k].node, wordcount+1); 
      
  }
  
  return n;
}

/* Functions for reporting frequent closed patterns */

struct patgroup *find_patgroup(struct patgroup *node, support_t support)
{

  if (support == node->support)  { return node; }

  if (support < node->support  &&  node->left) {
    return find_patgroup(node->left, support);
  }
  
  if (support > node->support  &&  node->right) {
    return find_patgroup(node->right, support);
  }
  
  if (support < node->support) {
  
    node->left = (struct patgroup *) malloc(sizeof(struct patgroup));
    node->left->support = support;
    node->left->patterns = 0;
    node->left->left = 0;
    node->left->right = 0;
    
    return node->left;    
    
  } else {
  
    node->right = (struct patgroup *) malloc(sizeof(struct patgroup));
    node->right->support = support;
    node->right->patterns = 0;
    node->right->left = 0;
    node->right->right = 0;
    
    return node->right;
    
  }

}


void add_to_patgroup_tree(support_t support, int wordcount)
{
  struct patgroup *ptr1;
  struct pattern *ptr2, *prev2, *new2;
  int i, card1, card2;
  wordnumber_t k;
  
  if (!PATGROUPS) {
  
    PATGROUPS = (struct patgroup *) malloc(sizeof(struct patgroup));
    
    PATGROUPS->support = support;
    PATGROUPS->patterns = 0;
    PATGROUPS->left = 0;
    PATGROUPS->right = 0;
    
    ptr1 = PATGROUPS;
    
  } else { 
  
    ptr1 = find_patgroup(PATGROUPS, support); 
    
  }
  
  prev2 = 0;
  ptr2 = ptr1->patterns;  
  
  while (ptr2) {
  
    card1 = wordcount;
    card2 = ptr2->wordcount;
    
    for (i = 0; i < ptr2->wordcount; ++i) {
  
      if (MASK[ptr2->numbers[i]]) {
        --card1;
        --card2;
      }
      
    }
    
    if (!card1)  { return; }

    if (!card2) {
    
      if (prev2) { 
        prev2->next = ptr2->next; 
      } else { 
        ptr1->patterns = ptr2->next;
      }

      free((void *) ptr2->numbers);      
      free((void *) ptr2);

      if (prev2) { 
        ptr2 = prev2->next; 
      } else { 
        ptr2 = ptr1->patterns;
      }

      continue;
            
    }
    
    prev2 = ptr2;
    ptr2 = ptr2->next;
    
  }
  
  new2 = (struct pattern *) malloc(sizeof(struct pattern));
  new2->numbers = (wordnumber_t *) malloc(sizeof(wordnumber_t) * wordcount);
  
  for (i = 0; i < wordcount; ++i)  { new2->numbers[i] = NUMBERS[i]; }
  
  new2->wordcount = wordcount;
  new2->next = 0;

  if (prev2) { prev2->next = new2; } else { ptr1->patterns = new2; }
  
}


void find_closed_patterns(struct node *node, int wordcount)
{
  wordnumber_t k;
  char pot_closed;
    
  if (node != PATTREE) { pot_closed = 1; } else { pot_closed = 0; }
  
  for (k = 0; k < node->childcount; ++k) {

    if (node->support == node->children[k].node->support) { pot_closed = 0; }

    MASK[node->children[k].number] = 1;
    NUMBERS[wordcount] = node->children[k].number;
    
    find_closed_patterns(node->children[k].node, wordcount+1); 
    
    MASK[node->children[k].number] = 0;
    
  }

  if (pot_closed) { 
    add_to_patgroup_tree(node->support, wordcount); 
  }
  
}


unsigned long long report_closed_patterns(struct patgroup *node)
{
  struct pattern *ptr;
  char number[5];
  int i, j, k;
  unsigned long long n;
  
  n = 0;
    
  for (ptr = node->patterns; ptr; ptr = ptr->next) {

    if (PREFIX) {
    
      qsort((void *) ptr->numbers, (size_t) ptr->wordcount,
            sizeof(wordnumber_t), word_compare);

      j = 1;
      
      for (i = 0; i < ptr->wordcount; ++i) {
      
        strncpy(number, WORDNUMBERS[ptr->numbers[i]]->key, PREFIX);
        number[PREFIX] = 0;

        k = (int) strtol(number, 0, 16);
        while (j < k) { printf("* "); ++j; }
        j = k + 1;
        
        printf("%s ", WORDNUMBERS[ptr->numbers[i]]->key+PREFIX);
        
      }
    
    } else {

      for (i = 0; i < ptr->wordcount; ++i) {
        printf("%s ", WORDNUMBERS[ptr->numbers[i]]->key);
      }
    
    }
      
    printf("\nSupport: %llu\n\n", (unsigned long long) node->support);
      
    ++n;
      
  }

  if (node->left)  { n += report_closed_patterns(node->left); }
  if (node->right)  { n += report_closed_patterns(node->right); }
      
  return n;
}

/* Memory release functions */

void free_tree(struct node *node)
{
  wordnumber_t k;

  for (k = 0; k < node->childcount; ++k) {

    if (!node->children[k].node->childcount) {

      free((void *) node->children[k].node);

    } else { 
    
      free_tree(node->children[k].node);
      
    }

  }

  if (node->childcount)  { free((void *) node->children); }
  
  free((void *) node);
}


void free_patgroup_tree(struct patgroup *grp)
{
  struct pattern *pat, *patnext;
  
  if (grp->left)  { free_patgroup_tree(grp->left); }
  if (grp->right)  { free_patgroup_tree(grp->right); }
  
  pat = grp->patterns;
    
  while (pat) {
    patnext = pat->next;
    free((void *) pat->numbers);
    free((void *) pat);
    pat = patnext;
  }

  free((void *) grp);
}


void free_inputfiles(void)
{
  struct inputfile *ptr, *next;

  ptr = INPUTFILES;

  while (ptr) {
    next = ptr->next;
    free((void *) ptr->name);
    free((void *) ptr);
    ptr = next;
  }
}


void free_template(void)
{
  struct templelem *ptr, *next;

  ptr = TEMPLATE;

  while (ptr) {
    next = ptr->next;
    free((void *) ptr->str);
    free((void *) ptr);
    ptr = next;
  }
}


int parse_options(int argc, char **argv)
{
  extern char *optarg;
  extern int optind;
  int c, i, start, len;
  struct templelem *template;
  struct inputfile *ptr;
  char *addr;

  while ((c = getopt(argc, argv, "b:cd:f:gi:l:n:o:s:t:v:w:z:")) != -1) {

    switch(c) { 
    case 'b':
      BYTEOFFSET = atoi(optarg);
      break;
    case 'c':
      CLOSED = 1;
      break;
    case 'd':
      DELIM = (char *) malloc(strlen(optarg) + 1);
      strcpy(DELIM, optarg);
      break;
    case 'f':
      FILTER = (char *) malloc(strlen(optarg) + 1);
      strcpy(FILTER, optarg);
      break;
    case 'g':
      PREFIX = 0;
      break;
    case 'i':
      INITSEED = atoi(optarg);
      break;
    case 'l':
      LENGTH = atoi(optarg);
      break;
    case 'n':
      CACHESUPPORT = atoi(optarg);
      break;
    case 'o':
      OUTOFCACHEFILE = (char *) malloc(strlen(optarg) + 1);
      strcpy(OUTOFCACHEFILE, optarg);
      break;
    case 's':
      if (optarg[strlen(optarg) - 1] == '%') { 
        PCTSUPPORT = atof(optarg); 
      } else { 
        SUPPORT = atoi(optarg); 
      }
      break;
    case 't':
      i = 0;
      while (optarg[i]) {
        if (TEMPLATE) {
          template->next = (struct templelem *) malloc(sizeof(struct templelem));
          template = template->next;
        } else {
          TEMPLATE = (struct templelem *) malloc(sizeof(struct templelem));
          template = TEMPLATE;
        }
        if (optarg[i] != BACKREFCHAR) {
          start = i;
          while (optarg[i] && optarg[i] != BACKREFCHAR)  { ++i; }
          len = i - start;
          template->str = (char *) malloc(len + 1);
          strncpy(template->str, optarg + start, len);
          template->str[len] = 0;
          template->data = len;
        } else {
          template->str = 0;
          template->data = (int) strtol(optarg + i + 1, &addr, 10);
          i = addr - optarg;
        }
        template->next = 0;
      }
      break;
    case 'v':
      WORDVECTORSIZE = atoi(optarg);
      break;
    case 'w':
      WORDTABLESIZE = atoi(optarg);
      break;
    case 'z':
      CACHEVECTORSIZE = atoi(optarg);
      break;
    case '?':
      return 0;
    }
    
  }
  
  if (optind < argc) {
  
    INPUTFILES = (struct inputfile *) malloc(sizeof(struct inputfile));
    ptr = INPUTFILES;
    
    while (optind < argc) {
      ptr->name = (char *) malloc(strlen(argv[optind]) + 1);
      strcpy(ptr->name, argv[optind]);
      if (++optind == argc)  { break; }
      ptr->next = (struct inputfile *) malloc(sizeof(struct inputfile));
      ptr = ptr->next;
    }
    
    ptr->next = 0;

  }
  
  return 1;
}


void print_usage(char *progname) {
  fprintf(stderr, "\n");
  fprintf(stderr, "LogHound version 0.01, Copyright (C) 2004 Risto Vaarandi\n");
  fprintf(stderr, "Usage: %s [-b <byte offset>] [-c] [-d <regexp>]\n", 
                  progname);
  fprintf(stderr, "[-f <regexp>] [-g] [-i <seed>] [-l <max itemset size>]\n");
  fprintf(stderr, "[-n <cache trie support>] [-o <out-of-cache file>]\n");
  fprintf(stderr, "[-t <template>] [-v <item vector size>] [-w <item table size>]\n");
  fprintf(stderr, "[-z <transaction vector size>] -s <support> <input files>\n");
}


int main(int argc, char **argv)
{
  char logstr[MAXLOGMSGLEN];
  tableindex_t effect; 
  wordnumber_t number;
  struct templelem *ptr;
  support_t lines, nodes;
  unsigned long long patterns;
  int i;

  /* Default values for commandline options */

  BYTEOFFSET = 0;
  CACHESUPPORT = 0;
  CLOSED = 0;
  DELIM = 0;
  FILTER = 0;
  INITSEED = 1;
  LENGTH = 0;
  OUTOFCACHEFILE = 0;
  PCTSUPPORT = 0;
  PREFIX = 4;
  SUPPORT = 0;
  TEMPLATE = 0;
  WORDVECTORSIZE = 0;
  WORDTABLESIZE = 100000;
  
  INPUTFILES = 0;

  /* Parse commandline options */
    
  if (!parse_options(argc, argv)) {
    print_usage(argv[0]);
    exit(1);
  }

  if (!INPUTFILES) {
    fprintf(stderr, "No input files specified\n");
    print_usage(argv[0]);
    exit(1);
  }

  if (BYTEOFFSET < 0) {
    fprintf(stderr, 
      "'-b' option requires a positive number or zero as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }
  
  if (CACHESUPPORT < 0) {
    fprintf(stderr, 
      "'-c' option requires a positive number or zero as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }

  if (DELIM) {  
    if (regcomp(&DELIM_REGEX, DELIM, REG_EXTENDED)) {
      fprintf(stderr, 
        "Bad regular expression given with '-d' option\n", DELIM);
      print_usage(argv[0]);
      exit(1);
    }
  } else { 
    regcomp(&DELIM_REGEX, "[ \t]+", REG_EXTENDED);
  }
    
  if (FILTER  &&  regcomp(&FILTER_REGEX, FILTER, REG_EXTENDED)) {
    fprintf(stderr, 
      "Bad regular expression given with '-f' option\n", FILTER);
    print_usage(argv[0]);
    exit(1);
  }
  
  if (INITSEED < 0) {
    fprintf(stderr,
      "'-i' option requires a positive number or zero as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }
  
  if (LENGTH < 0) {
    fprintf(stderr,
      "'-l' option requires a positive number or zero as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }

  if (SUPPORT <= 0  &&  PCTSUPPORT <=0) {
    fprintf(stderr, 
      "'-s' option requires a positive number as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }

  for (ptr = TEMPLATE; ptr; ptr = ptr->next) {
    if (!ptr->str  &&  (ptr->data < 0 || ptr->data > MAXPARANEXPR - 1)) {
      fprintf(stderr, 
        "'-t' option requires backreference variables to be in range $0..$%d\n",
        MAXPARANEXPR - 1);
      print_usage(argv[0]);
      exit(1);
    }
  }

  if (WORDVECTORSIZE < 0) {
    fprintf(stderr, 
      "'-v' option requires a positive number or zero as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }

  if (WORDTABLESIZE <= 0) {
    fprintf(stderr, 
      "'-w' option requires a positive number as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }

  if (CACHEVECTORSIZE < 0) {
    fprintf(stderr, 
      "'-z' option requires a positive number or zero as parameter\n");
    print_usage(argv[0]);
    exit(1);
  }

  /* Do the work */

  log_msg("Starting");
  
  srand(INITSEED);
  WORDVECTORSEED = rand();
  CACHEVECTORSEED = rand();
  WORDTABLESEED = rand();
  
  if (WORDVECTORSIZE) {

    log_msg("Creating the item summary vector");

    WORDVECTOR = (support_t *) malloc(sizeof(support_t) * WORDVECTORSIZE);

    effect = create_word_vector();

    sprintf(logstr, "%llu slots in the summary vector >= support threshold", 
                    (unsigned long long) effect);
    log_msg(logstr);

  }

  log_msg("Finding frequent items");

  WORDTABLE = (struct elem **) malloc(sizeof(struct elem *) * WORDTABLESIZE);

  number = create_vocabulary();

  sprintf(logstr, "%llu items counted", (unsigned long long) number);
  log_msg(logstr);

  if (WORDVECTORSIZE)  { free((void *) WORDVECTOR); }
  
  WORDNUMBERS = (struct elem **) malloc(sizeof(struct elem *) * number);
  
  WORDNUM = find_frequent_words();

  sprintf(logstr, "%llu frequent items found", (unsigned long long) WORDNUM);
  log_msg(logstr);  

  WORDNUMBYTES = 1;
  number = WORDNUM;
  while (number >>= 8)  { ++WORDNUMBYTES; }
  
  if (!CACHEVECTORSIZE)  { CACHEVECTORSIZE = WORDNUM * 100; }
  if (!CACHESUPPORT  ||  !OUTOFCACHEFILE)  { CACHEVECTORSIZE = 0; }
  
  log_msg("Creating mining data structures");

  if (CACHEVECTORSIZE) {
    CACHEVECTOR = (support_t *) malloc(sizeof(support_t) * CACHEVECTORSIZE);
  }

  WORDMATRIX = (wordnumber_t **) malloc(sizeof(wordnumber_t *) * WORDNUM);
  ROWLENGTH = (wordnumber_t *) malloc(sizeof(wordnumber_t) * WORDNUM);
  CONVTABLE = (wordnumber_t *) malloc(sizeof(wordnumber_t) * WORDNUM);

  create_mining_data_struct();

  log_msg("Creating the cache trie");
  
  DATANODES = 0;
  
  lines = create_data_tree();

  sprintf(logstr, "%llu transactions and %llu nodes in the cache trie", 
          (unsigned long long) lines, (unsigned long long) DATANODES);
  log_msg(logstr);

  if (CACHEVECTORSIZE)  { free((void *) CACHEVECTOR); }
  free((void *) CONVTABLE);
  
  log_msg("Building the itemset trie");
  
  PATNODES = 0;
  
  create_first_level();

  sprintf(logstr, "%llu nodes in the itemset trie", 
                  (unsigned long long) PATNODES);
  log_msg(logstr);
  
  i = 2;
  nodes = PATNODES;

  PATH = (char *) malloc(sizeof(char) * WORDNUM);
  for (number = 0; number < WORDNUM; ++number) { PATH[number] = 0; }
  
  for (;;) {

    sprintf(logstr, "Generating candidate nodes at depth %d", i);
    log_msg(logstr);
        
    gen_candidates(PATTREE, 0, i);
            
    sprintf(logstr, "Building layer %d of the itemset trie", i);
    log_msg(logstr);

    create_next_level(i, DATATREE, 0);
    if (OUTOFCACHEFILE)  { create_next_level2(i); }
    
    sprintf(logstr, "%llu nodes in the itemset trie", 
                    (unsigned long long) PATNODES);
    log_msg(logstr);

    if (PATNODES == nodes) {
      sprintf(logstr, "Maximum frequent itemset size %d\n", i-1);
      log_msg(logstr);
      break;
    }

    sprintf(logstr, "Pruning candidate nodes at depth %d", i);
    log_msg(logstr);    
    
    prune_leaves(PATTREE, i);
    
    sprintf(logstr, "%llu nodes in the itemset trie", 
                    (unsigned long long) PATNODES, i);
    log_msg(logstr);

    if (PATNODES == nodes) {
      sprintf(logstr, "Maximum frequent itemset size %d\n", i-1);
      log_msg(logstr);
      break;
    }
    
    if (i == LENGTH) {
      sprintf(logstr, "Found frequent itemsets of size <= %d\n", i);
      log_msg(logstr);
      break;
    }
    
    nodes = PATNODES;
    
    ++i;

  }

  free((void *) PATH);
  
  MASK = (char *) malloc(sizeof(char) * WORDNUM);
  for (number = 0; number < WORDNUM; ++number) { MASK[number] = 0; }

  if (CLOSED) {

    log_msg("Finding closed frequent itemsets");

    PATGROUPS = 0;

    find_closed_patterns(PATTREE, 0);

    patterns = report_closed_patterns(PATGROUPS);

  } else {
    
    log_msg("Finding frequent itemsets");
  
    patterns = find_patterns(PATTREE, 0);

  }

  sprintf(logstr, "%llu itemsets found", patterns);
  log_msg(logstr);  
  
  log_msg("Analysis complete");

  free_tree(PATTREE);
  free_tree(DATATREE);
  
  if (CLOSED && PATGROUPS)  { free_patgroup_tree(PATGROUPS); }
    
  free_table(WORDTABLE, WORDTABLESIZE);
    
  for (number = 0; number < WORDNUM; ++number) {
    if (ROWLENGTH[number])  { free((void *) WORDMATRIX[number]); }
  }
  
  free((void *) WORDMATRIX);
  free((void *) ROWLENGTH);
  
  free((void *) MASK);

  free_inputfiles();
  free_template();

  regfree(&DELIM_REGEX);
  if (FILTER)  { regfree(&FILTER_REGEX); }

  if (DELIM)  { free((void *) DELIM); }
  if (FILTER)  { free((void *) FILTER); }
  if (OUTOFCACHEFILE)  { free((void *) OUTOFCACHEFILE); }
    
  exit(0);
}
