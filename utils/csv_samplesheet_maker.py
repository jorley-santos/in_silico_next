'''
Developed by: Jorley Santos
Goal: This script generates a .csv file with the absolute path of each file in an input folder. 
Ideal to generate Nextflow input .csv files.
'''

from os import listdir

def csv_samplesheet_maker(input_folder):
    '''
    input: absolute path for the directory containing the files
    output: a single csv file containing the file names of each sample in the input directory
    '''
    
    with open("data/samplesheet.csv", "w") as text:          # creating new csv file i
        text.write("file_id,file_path\n")                    # creating header for the new csv file

        # iterating through each file in input given folder
        for i in listdir(input_folder):              

            text.write(i + ",")                              # adding the file name to the 1st column
            text.write(input_folder +"/" + str(i))                # adding the file absolute path to the 2nd column
            text.write("\n")

csv_samplesheet_maker("/home/jubarte/bioinformatic-projects/nextflow-pipelines/personal-projects/insilicoseq-microbiome-pipeline/data/genomes")