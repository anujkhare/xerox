# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <codecell>

%reset

# <codecell>

import re
from os import listdir

# <codecell>

with open('fields') as f:
    field_names = [x.strip('\n').split(': ') for x in f.readlines()]

# <codecell>

vitals = field_names[1: 7]
labs = field_names[9:]

# <codecell>

str1 = ','.join([labs[i][1] for i in xrange(len(labs))])

# <codecell>

str2 = ','.join([vitals[i][1] for i in xrange(len(vitals))])

# <codecell>

str1

# <codecell>

str2

# <codecell>

for i, row in enumerate(labs):
    print i, row

# <codecell>

# Remove the missing values
# labs.pop(18)
# labs.pop(22)

# <codecell>

# This will be the default value of each row
dict_vitals = {vitals[i][1]: 'NA' for i in xrange(len(vitals))}
dict_labs = {labs[i][1]: 'NA' for i in xrange(len(labs))}

# <codecell>

def get_seconds(time):
    [hr, sec] = time.split(':')
    return int(hr) * 3600 + int(sec) * 60

# <codecell>

def print_record_labs(p_id, record_time, t_labs):
        record_labs = [p_id, record_time]
        record_labs.extend([t_labs[labs[i][1]]
                             for i in xrange(len(labs))])
        
        string = ','.join([str(e) for e in record_labs])
        f_labs.write(string)
        f_labs.write('\n')
#         print string

# <codecell>

def print_record_vitals(p_id, record_time, t_vitals):
        record_vitals = [p_id, record_time]
        record_vitals.extend([t_vitals[vitals[i][1]]
                             for i in xrange(len(vitals))])
        
        string = ','.join([str(e) for e in record_vitals])
        f_vitals.write(string)
        f_vitals.write('\n')
#         print string

# <codecell>

def process_patient_file(content):
    # Read first lines to generate id file
    if(content[2][1] != 'Age' or content[1][1] != 'RecordID'):
        print "ERROR!"
    p_id = int(content[1][2])
    p_age = int(content[2][2])

    string = ','.join([str(p_id), str(p_age)])
    f_age.write(string)
    f_age.write('\n')
    
    # Read row by row and club entries with same timestamp for vitals and labs
    record_time = 0  
    t_vitals = dict_vitals.copy()
    t_labs = dict_labs.copy()

#     k = 0
    for row in content[1:]:
        row_time = get_seconds(row[0])

#         print row
        
        # we will skip the initial entries (time=0) 
        if (record_time == 0):
            record_time = row_time
        if (row_time == 0):
            continue

        if (row_time == record_time):
            if(t_vitals.has_key(row[1])):
                t_vitals[row[1]] = float(row[2])
            if(t_labs.has_key(row[1])):
                t_labs[row[1]] = float(row[2])

        else:  # New timestamp
#             k = k + 1
#             print k
            print_record_labs(p_id, record_time, t_labs)
            print_record_vitals(p_id, record_time, t_vitals)

            # Initialize for the next record
            record_time = row_time
            t_labs = dict_labs.copy()
            t_vitals = dict_vitals.copy()

    # Last record is not printed
    print_record_labs(p_id, record_time, t_labs)
    print_record_vitals(p_id, record_time, t_vitals)

# <codecell>

patient_file = 'data_train/133687.txt'

# <codecell>

# Open output files
f_vitals = open('train_vitals.csv', 'w') 
f_labs = open('train_labs.csv', 'w')
f_age = open('train_age.csv', 'w')
#f_labels = open('train_labels.csv', 'w')

# Process each patient file
for patient_file in ['data_train/' + f for f in listdir('data_train/')]:
    with open(patient_file) as f:
        content = [re.split(r',', x.strip('\n')) for x in f.readlines()]
        process_patient_file(content)

    # Flush streams
    f_age.flush()
#     f_vitals.flush()
#     f_labs.flush()
f_age.close()
f_vitals.close()
f_labs.close()

