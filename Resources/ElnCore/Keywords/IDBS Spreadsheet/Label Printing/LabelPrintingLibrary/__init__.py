
import sys
import os
import glob
from WMILibrary import WMI_commands

class LabelPrintingLibrary():
    
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'
    
    def rename_unknown_file(self, file_path, new_path):
        """
        Renames the file_path file to new_path. Please note that this keyword requires full file paths in both arguments. Supports pattern matching as follows:
        
        Example use:
        
        | Rename Unknown File   | C:\\MyFolder\\*.txt  | C:\\MyFolder\\renamedfile.txt |\n
        
        This will rename the first .txt file found in MyFolder to renamedfile.txt
        
        """
        matching_names = glob.glob(file_path)
        if matching_names:
            print 'Attempting to rename ' + str(matching_names[0]) + ' to ' + str(new_path)
            os.rename(matching_names[0], new_path)
        else:
            raise LabelPrintingException("Couldn't find the given file to rename")
        pass
    
    def get_remote_file (self, ip, username, password, remote_path, local_folder, new_name="retrieved_file.file"):
        """
        
        Copies the the remote remote_path file to the local new_path folder and renames it. Please note that this keyword requires full file paths. Supports pattern matching as follows:
        
        Example use:
        
        | Get Remote File   | RemoteMachineName  | Administrator | Password  | C:\\RemoteFolder\\*.txt  | C:\\LocalFolder\\renamedfile.txt |\n
        
        This will copy the first .txt file found in RemoteFolder to LocalFolder and rename it renamedfile.txt
        
        Will return the new file name when used to initialise a variable.
        
        """
        
        conn = WMI_commands.WMICommands()
        conn.open_connection (ip, username, password)
        
        real_destination_folder = os.path.normpath(local_folder)
        remote_folder = os.path.dirname(remote_path)
        
        # Convert to UNC path and get the file name
        unc_source_path = conn.current_connection._get_remote_path(remote_path)
        
        # Supporting pattern matching in the remote machine to find the file
        matching_names = glob.glob(unc_source_path)
                
        if matching_names:
            #Get the file name
            unc_source_path = matching_names[0]
            file_name = os.path.basename(unc_source_path)
            
            #Copy it to the local machine
            
            temp = os.path.join(remote_folder, file_name)
            remote_file_path = temp
            destination_file_path = os.path.join (local_folder, file_name)
            print 'Attempting to copy ' + remote_file_path + ' from remote machine to the local machine.'
            conn.current_connection.get_file(remote_file_path, destination_file_path)
            
            #Form the new file path
            new_local_path = os.path.join(real_destination_folder, file_name)
            
            #Rename the new file
            new_name = os.path.join(real_destination_folder, new_name)
            
            print 'Attempting to rename ' + str(destination_file_path) + ' to ' + str(new_name)
            os.rename(new_local_path, new_name)
        else:
            raise LabelPrintingException("Remote file " + remote_path + " does not exist.")
        conn.close_connection()
        return new_name
        
            
class LabelPrintingException(Exception):
    def __init__(self,value):
        self.value = value

    def __str__(self):
        return repr(self.value)