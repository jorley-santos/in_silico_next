'''
Developed by: Jorley Santos
Goal: This script generates a single .csv file containing the absolute
file path of genomes stored in a directory. Ideal to generate Nextflow
input csv files.
'''

from os import listdir,path

def csv_samplesheet_maker(input_folder):
    '''
    input: directory containing multiple files to be used as input in Nextflow
    output: a single csv file containing the file names
    '''
    
    with open("samplesheet.csv", "w") as text:          #Creating new csv file
        text.write("file_id,file_path\n")          # creating header for the csv file

        # iterating through each file in the given folder
        #Writing their file ID and full path to a line of samplesheet.csv
        for i in listdir(input_folder):              
            text.write(i + ",")
            text.write(path.abspath(i))
            text.write("\n")
