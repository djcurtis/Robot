############################################################################
#
# Copyright (C) 1993-2011 ID Business Solutions Limited
# All rights reserved
# 
# entitytree.py
#
############################################################################

from rest.restclient import RestClient
import urllib
import json
import uuid
import binascii

WORKFLOWS_ENDPOINT = "workflows/"
WORKFLOW_CONFIG_ENDPOINT = "workflowconfigurations/"
TASKS_ENDPOINT = "tasks/"

class WorkflowsClient(RestClient):
    
    test_ignore_task = str(uuid.uuid1())
    test_resend_task = str(uuid.uuid1())
    test_cancel_task = str(uuid.uuid1())
    test_close_task = str(uuid.uuid1())
    test_complete_task = str(uuid.uuid1())
    test_reject_task = str(uuid.uuid1())
    test_accept_task = str(uuid.uuid1())
    
    '''
    All workflow configuration methods
    '''
    def get_workflow_request(self,entityid,configuration):
        return self._get(WORKFLOW_CONFIG_ENDPOINT + "workflowconfigurations/workflowrequest?entityid="+str(entityid)+"&configuration="+configuration,{'Accept' : 'application/json;charset=utf-8','Content-Type' : 'application/json;charset=utf-8'})

    def get_configuration(self,configuration):
        print WORKFLOW_CONFIG_ENDPOINT + configuration
        return self._get(WORKFLOW_CONFIG_ENDPOINT + configuration)

    def get_configurations(self,entityid,configuration):
        return self._get(WORKFLOW_CONFIG_ENDPOINT + "?entityid="+str(entityid)+"&configuration="+configuration)

    '''
    All workflow methods
    '''

    def get_workflow_by_id(self,workflowid):
       return self._get(WORKFLOWS_ENDPOINT + str(workflowid))

    def create_workflow(self,entityid,configuration,duedate,task_user):
        workflowrequest_dto = {
              "forEntity":
                {"entitySelectionType":"BY_ENTITY_ID","entitySelected": str(entityid) },
                "fromConfiguration": configuration, "dueDate": duedate,  
                "tasks":{"taskSetup":[{"taskName": self.test_ignore_task, "assignedUsers":{"user": [task_user]}, "assignedGroups":{"group":[]}, "comments": "test_comments", "taskParameters":{ "name": "test_param1", "value": "test_object"}},{"taskName": self.test_resend_task, "assignedUsers":{"user": [task_user]}, "assignedGroups":{"group":[]}, "comments": "test_comments", "taskParameters":{ "name": "test_param1", "value": "test_object"}},{"taskName": self.test_cancel_task, "assignedUsers":{"user": [task_user]}, "assignedGroups":{"group":[]}, "comments": "test_comments", "taskParameters":{ "name": "test_param1", "value": "test_object"}},{"taskName": self.test_close_task, "assignedUsers":{"user": [task_user]}, "assignedGroups":{"group":[]}, "comments": "test_comments", "taskParameters":{ "name": "test_param1", "value": "test_object"}},{"taskName": self.test_complete_task, "assignedUsers":{"user": [task_user]}, "assignedGroups":{"group":[]}, "comments": "test_comments", "taskParameters":{ "name": "test_param1", "value": "test_object"}},{"taskName": self.test_reject_task, "assignedUsers":{"user": [task_user]}, "assignedGroups":{"group":[]}, "comments": "test_comments", "taskParameters":{ "name": "test_param1", "value": "test_object"}},{"taskName": self.test_accept_task, "assignedUsers":{"user": [task_user]}, "assignedGroups":{"group":[]}, "comments": "test_comments", "taskParameters":{ "name": "test_param1", "value": "test_object"}}]}, "sendEmailNotifications": False, "lockExperiment" : False, "priority": "NORMAL"
            }
        json_wfreq = json.dumps(workflowrequest_dto)
        
        return self._post(WORKFLOWS_ENDPOINT, json_wfreq )

        
    def get_active_workflows(self,entityid):
       return self._get(WORKFLOWS_ENDPOINT + "activeworkflows?entityid="+str(entityid))
       
    def get_workflows_tasks(self,workflowid):
       return self._get(WORKFLOWS_ENDPOINT + str(workflowid) + "/tasks")
       
    def get_task_by_id(self,taskid):
        return self._get(TASKS_ENDPOINT + taskid)

    def find_tasks(self):
        taskfilter = { "viewAnyTasks" : True, "includeAssignedSet" : True, "includeSentSet": True, "includeResponsibleSet": True, "taskProperties" : {}}
        json_taskfilter = json.dumps(taskfilter)
        return self._post(TASKS_ENDPOINT ,json_taskfilter)
        
    def get_task_statuses(self):
        return self._get(TASKS_ENDPOINT + "statuses")

    def get_task_types(self):
        return self._get(TASKS_ENDPOINT + "types")

    def update_comments(self,taskid,comments):
        comments_dto = { "comments" : comments
        }
        json_comments = json.dumps(comments_dto)
        self._post(TASKS_ENDPOINT + taskid + "/comments",json_comments)
        
    def accept_task(self,taskid):
        self._post(TASKS_ENDPOINT + taskid + "/accept",None)
        
    def reject_task(self,taskid,comments):
        comments_dto = { "comments" : comments
        }
        json_comments = json.dumps(comments_dto)
        self._post(TASKS_ENDPOINT + taskid + "/reject",json_comments)
        
    def ignore_task(self,taskid):
        self._post(TASKS_ENDPOINT + taskid + "/ignore",None)

    def complete_task(self,taskid):
        self._post(TASKS_ENDPOINT + taskid + "/complete",None)

    def close_task(self,taskid):
        self._post(TASKS_ENDPOINT + taskid + "/close",None)

    def cancel_task(self,taskid):
        self._post(TASKS_ENDPOINT + taskid + "/cancel",None)

    def resend_task(self,taskid):
        self._post(TASKS_ENDPOINT + taskid + "/resend",None)

    def set_actioning_record(self,taskid,recordid):
        self._post(TASKS_ENDPOINT + taskid + "/setactioningrecord?recordid="+recordid,None)

    def add_attachment(self,taskid,attachmentName,filename, attachedby, attachmentdata):
        attachment = { "attachmentId": attachmentName, "fileName": filename, "attachedBy": attachedby, "attachedDate": "2011-01-01T00:00:00.000+00:00", "contentSize": "5", "attachmentContent" : attachmentdata}
        json_attach = json.dumps(attachment)
        self._post(TASKS_ENDPOINT + taskid + "/attachments",json_attach)

    def get_task_attachment_by_id(self,taskid,attachmentid):
        return self._get(TASKS_ENDPOINT + taskid +"/attachments/" + attachmentid,{'Accept' : '*/*'})
        
    def delete_task_attachment_by_id(self,taskid,attachmentid):
        self._delete(TASKS_ENDPOINT + taskid +"/attachments/" + str(attachmentid))