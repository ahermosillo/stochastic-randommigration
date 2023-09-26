import time
import os
import shutil

directory = "./"
files_in_directory = os.listdir(directory)
filtered_files = [file for file in files_in_directory if file.endswith(".dmp") \
    or file.endswith(".tmp") or file.endswith(".out") or file.endswith(".aei")\
        or file.endswith(".dat")]
# filtered_files = [file if file.endswith(".dmp") else file.endswith(".tmp") for file in files_in_directory]
# filtered_files.append([file for file in files_in_directory if file.endswith(".tmp")])
print("these are the files we are going to delete. Are you sure you want to proceed?\n\
    type y or n for yes or no")
print(filtered_files)
yn = input()
if yn == 'y':
    for file in filtered_files:
        path_to_file = os.path.join(directory, file)
        os.remove(path_to_file)
        print("deleted ", file)
else:
    print("files were not deleted")