import sys
import unittest
import urllib2
from rest.config import set_server
from workflowclient import WorkflowsClient
wf_client = WorkflowsClient()
set_server(sys.argv[1], sys.argv[2])

class TestWorkflowService(unittest.TestCase):
    
    new_workflow = 0
    new_workflow_config = 0
    
    '''
        Please pre configure a configuration using the thick client with name ("test_configuration") for these tests to run successfully
        To do this, Start the thick client, Right click on the Administrator/s group -> configure -> workflows
        Create new configuration and change the name to test_configuration.Click apply and close the window
    '''
    
    def findTaskIdFromTaskName(self,tasklist,task_name):
        for td in tasklist:
            if td.taskName == task_name:
                return td.taskId
        
    def findTaskId(self,taskname):
        SAPITaskDetailSequence = wf_client.get_workflows_tasks(self.new_workflow)
        test_task_id = self.findTaskIdFromTaskName(SAPITaskDetailSequence.taskDetail,taskname)
        return str(test_task_id)

    def test_001_getWorkFlowConfigurations(self):
        SAPIWorkflowConfigurationSequence = wf_client.get_configurations(2,"test_configuration")
        TestWorkflowService.new_workflow_config = SAPIWorkflowConfigurationSequence.workflowConfiguration[0].workflowConfigurationId
        self.assertIsNotNone(SAPIWorkflowConfigurationSequence.workflowConfiguration,'get configurations failed')

    def test_002_getWorkFlowConfiguration(self):
        sapiWorkflowConfiguration = wf_client.get_configuration(str(TestWorkflowService.new_workflow_config))
        self.assertIsNotNone(sapiWorkflowConfiguration,'get configuration returned null')

    def test_003_getWorkFlowRequest(self):
        SAPIWorkflowRequest = wf_client.get_workflow_request(2,"Test Configuration")
        self.assertIsNotNone(SAPIWorkflowRequest,'get Workflow request returned null')

    def test_004_createWorkflow(self):
        SAPICreateWorkflowResponse = wf_client.create_workflow(2,"Test Configuration","2011-01-01T00:00:00.000+00:00","Administrator")
        self.assertIsNotNone(SAPICreateWorkflowResponse,'create workflow returned null')
        TestWorkflowService.new_workflow = SAPICreateWorkflowResponse.workflowId
    
    def test_005_getWorkflowById(self):
        SAPIWorkflow = wf_client.get_workflow_by_id(TestWorkflowService.new_workflow)
        self.assertIsNotNone(SAPIWorkflow,'get Workflow returned null')    
        self.assertEqual(SAPIWorkflow.entityId,"2",'work flow id should be same as the one created')
        
    def test_006_getActiveWorkflows(self):
        SAPIActiveWorkflowsResponse = wf_client.get_active_workflows(2)
        self.assertIsNotNone(SAPIActiveWorkflowsResponse,'get active workflows returned null')    
        self.assertTrue(SAPIActiveWorkflowsResponse.entityId.count("2")>0,'workflow for entity id 2 should be present')    

    def test_007_getWorkflowTasks(self):
        SAPITaskDetailSequence = wf_client.get_workflows_tasks(TestWorkflowService.new_workflow)
        self.assertIsNotNone(SAPITaskDetailSequence,'get active workflows returned null')    
        self.assertTrue(len(SAPITaskDetailSequence.taskDetail)>0,'workflow should have had one task with "test_task" as task name')  
        
    created_task_id = 0

    def test_008_getTaskById(self):
        SAPITaskDetailSequence = wf_client.get_workflows_tasks(self.new_workflow)
        test_accept_task_id = self.findTaskIdFromTaskName(SAPITaskDetailSequence.taskDetail,wf_client.test_accept_task)
        SAPITaskDetail = wf_client.get_task_by_id(str(test_accept_task_id))
        self.assertIsNotNone(SAPITaskDetail,'get configuration returned null')
        
    def test_009_findTasks(self):
        SAPITaskDetailSequence = wf_client.find_tasks()
        self.assertTrue(len(SAPITaskDetailSequence.taskDetail)>0,'Find task should return atleast 1 tasks')

    def test_010_getTaskStatuses(self):
        SAPITaskStatusSequence = wf_client.get_task_statuses()
        self.assertEqual(len(SAPITaskStatusSequence.taskStatus),10,'should have had 10 statuses')

    def test_011_getTaskTypes(self):
        SAPITaskTypeSequence = wf_client.get_task_types()
        self.assertEqual(len(SAPITaskTypeSequence.taskType),7,'should have had 7 types')

    def test_012_updateTaskComments(self):
        # the update method appends the new comments to the existing comments. Check whether that is correct behaviour 
        test_accept_task_id = self.findTaskId(wf_client.test_accept_task)
        wf_client.update_comments(test_accept_task_id,"test comments")
        SAPITaskDetail = wf_client.get_task_by_id(test_accept_task_id)
        self.assertTrue(SAPITaskDetail.comments.count("test comments")>0,'comments not updated')

    def test_013_acceptTask(self):
        test_accept_task_id = self.findTaskId(wf_client.test_accept_task)
        wf_client.accept_task(test_accept_task_id)
        SAPITaskDetail = wf_client.get_task_by_id(test_accept_task_id)
        self.assertEqual(SAPITaskDetail.taskStatus,"IN_PROGRESS",'task not accepted')

    def test_014_rejectTask(self):
        test_reject_task_id = self.findTaskId(wf_client.test_reject_task)
        wf_client.reject_task(test_reject_task_id,"reject task")
        SAPITaskDetail = wf_client.get_task_by_id(test_reject_task_id)
        self.assertEqual(SAPITaskDetail.taskStatus,"REJECTED",'task not rejected')

    def test_015_ignoreTask(self):
        test_ignore_task_id = self.findTaskId(wf_client.test_ignore_task)
        try:
            wf_client.ignore_task(test_ignore_task_id)
        except urllib2.HTTPError, err:
           self.assertEqual(err.code, 500, 'should raise http error 500')

    def test_016_cancelTask(self):
        test_cancel_task_id = self.findTaskId(wf_client.test_cancel_task)
        wf_client.cancel_task(test_cancel_task_id)
        SAPITaskDetail = wf_client.get_task_by_id(test_cancel_task_id)
        self.assertEqual(SAPITaskDetail.taskStatus,"CANCELLED",'task not cancelled')

    # The task should be rejected to be resent
    def test_017_resendTask(self):
        test_resend_task_id = self.findTaskId(wf_client.test_reject_task)
        wf_client.resend_task(test_resend_task_id)
        SAPITaskDetail = wf_client.get_task_by_id(test_resend_task_id)
        self.assertEqual(SAPITaskDetail.taskStatus,"NEW",'task not resent')

    def test_018_addAttachment(self):
        test_accept_task_id = self.findTaskId(wf_client.test_accept_task)
        wf_client.add_attachment(test_accept_task_id,"test_attachment","test_filename","Administrator",'test data')
        SAPITaskDetail = wf_client.get_task_by_id(test_accept_task_id)
        self.assertTrue(self.findAttachmentInAttachmentList(SAPITaskDetail.attachments.attachment,"test_attachment"),'attachment not added successfully')

    def test_019_setActioningRecord(self):
        test_complete_task_id = self.findTaskId(wf_client.test_complete_task)
        wf_client.set_actioning_record(test_complete_task_id,"2")
        SAPITaskDetail = wf_client.get_task_by_id(test_complete_task_id)
        self.assertEqual(SAPITaskDetail.actioningRecordId,"2",'actioning record not set')

    # The task should have a actioning record to be marked complete
    def test_020_completeTask(self):
        test_complete_task_id = self.findTaskId(wf_client.test_complete_task)
        wf_client.complete_task(test_complete_task_id)
        SAPITaskDetail = wf_client.get_task_by_id(test_complete_task_id)
        self.assertEqual(SAPITaskDetail.taskStatus,"COMPLETED",'task not completed')

    # The task should either be completed or rejected to be closed
    def test_021_closeTask(self):
        test_close_task_id = self.findTaskId(wf_client.test_complete_task)
        wf_client.close_task(test_close_task_id)
        SAPITaskDetail = wf_client.get_task_by_id(test_close_task_id)
        self.assertEqual(SAPITaskDetail.taskStatus,"CLOSED",'task not closed')

    def test_022_getTaskAttachmentById(self):
        test_accept_task_id = self.findTaskId(wf_client.test_accept_task)
        attachment_data = wf_client.get_task_attachment_by_id(test_accept_task_id,"test_attachment")
        self.assertIsNotNone(attachment_data,'attachment not retrieved')
        
    def findAttachmentInAttachmentList(self,attlist,attId):
        for attachment in attlist:
            if attachment.attachmentId == attId:
                return True

    def test_023_deleteTaskAttachmentById(self):
        test_accept_task_id = self.findTaskId(wf_client.test_accept_task)
        wf_client.delete_task_attachment_by_id(test_accept_task_id,"test_attachment")
        SAPITaskDetail = wf_client.get_task_by_id(test_accept_task_id)
        self.assertEqual(len(SAPITaskDetail.attachments.attachment),0,'attachment not deleted')
        
        
suite = unittest.TestLoader().loadTestsFromTestCase(TestWorkflowService)
unittest.TextTestRunner(verbosity=2).run(suite)
