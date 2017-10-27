from robot.libraries.BuiltIn import BuiltIn
from robot.api import logger
import manual_action_frame
import os
import shutil

class ManualActionError (AssertionError):

    ROBOT_CONTINUE_ON_FAILURE = False

    def __init__(self, message):
        self.ROBOT_CONTINUE_ON_FAILURE = False
        self.value = '{0}. Stopping test case execution.'.format(message)

    def __str__(self):
        return repr(self.value)

class ManualActionOperations(object):

    def manual_action(self, instructions):
        manual_action_frame.show_instructions(instructions)
        self.process_user_basic_input()

    def process_user_basic_input(self):
        for note in manual_action_frame.notes:
            logger.info('Note: {0}'.format(note), html=True)
        for attachment in manual_action_frame.file_attachments:
            # Build name for file in output directory
            output_directory = BuiltIn().replace_variables('${OUTPUTDIR}')
            original_attachment_file_name = os.path.basename(attachment)
            original_attachment_extension = os.path.splitext(original_attachment_file_name)[1]
            # Make sure name is unique in output directory
            index = 1
            attachment_file_name = original_attachment_file_name
            while os.path.exists(os.path.join(output_directory, attachment_file_name)):
                index += 1
                attachment_file_name = '{0}_{1:04d}{2}'.format(os.path.splitext(original_attachment_file_name)[0],
                                                               index, original_attachment_extension)
            output_directory_attachment_file = os.path.join(output_directory, attachment_file_name)
            # Copy file to output directory
            shutil.copyfile(attachment, output_directory_attachment_file)
            # Add log message
            if original_attachment_extension.lower() in [".jpg", ".bmp", ",png"]:
                logger.info('File attachment: <a href="{0}"><img  src="{0}" width="300px" /></a>'.format(
                    output_directory_attachment_file.replace("\\", "/")), html=True)
            else:
                logger.info('File attachment: <a href="{0}">{1}</a>'.format(
                    output_directory_attachment_file.replace("\\", "/"), attachment_file_name), html=True)
        if not manual_action_frame.step_passed:
            raise ManualActionError(manual_action_frame.failure_message)

    def manual_check(self, instructions, expected):
        manual_action_frame.show_check(instructions, expected)
        self.process_user_basic_input()


