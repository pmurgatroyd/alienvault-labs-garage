from django.db import models

# Create your models here.


class BusinessProcess(models.Model):
    Name = models.CharField(max_length=200)
    Owner = models.CharField(max_length=200)
    
class ThreatSurface(models.Model):
    BusinessUnit = models.CharField(max_length=200)
    pub_date = models.DateTimeField('date published')
    BizProcess = models.ForeignKey(BusinessProcess)
