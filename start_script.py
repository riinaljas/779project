# -*- coding: utf-8 -*-
"""
Created on Fri Nov 15 17:19:02 2019

@author: aljas
"""

#Import Census and US packages
from census import Census
from us import states

c = Census("156fda6326a38745b31480cc7848c55e7f4fcf41")
c.acs5.get(('NAME', 'B25034_010E'),
          {'for': 'state:{}'.format(states.MD.fips)})

print(c)
print(states.MD.fips)

print(states.lookup('24').abbr)