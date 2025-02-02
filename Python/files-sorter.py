#Automatic file Sorter

import os, shutil

path = r"C:/Users/nahal/Downloads/File Sorter Py/"

folder_names = ['Text Files', 'Word Files', 'Excel Files', 'Image Files']
file_names = os.listdir(path)

for folder in range(0,4):
    if not os.path.exists(path + folder_names[folder]):
        os.makedirs(path + folder_names[folder])

for file in file_names:
    if '.txt' in file and not os.path.exists(path + 'Text Files/' + file):
        shutil.move(path + file,path + 'Text Files/' + file)
    elif '.docx' in file and not os.path.exists(path + 'Word Files/' + file):
        shutil.move(path + file,path + 'Word Files/' + file)
    elif '.xlsx' in file and not os.path.exists(path + 'Excel Files/' + file):
        shutil.move(path + file,path + 'Excel Files/' + file)
    elif '.png' in file and not os.path.exists(path + 'Image Files/' + file):
        shutil.move(path + file,path + 'Image Files/' + file)
