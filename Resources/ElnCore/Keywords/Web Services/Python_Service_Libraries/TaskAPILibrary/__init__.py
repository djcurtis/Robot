import os,sys

helper_dir = os.path.realpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'helper_libraries'))
sys.path.append(helper_dir)

from RestAPILibrary import RestApiLibrary
from xml.dom.minidom import parseString

from robot.api import logger

__version__ = "0.1"

root_task_url = "/ewb/services/1.0/tasks/"

find_tasks_to_cancel_filter_xml = """
<taskFilterSequence xmlns="http://workflow.services.ewb.idbs.com">
    <taskFilter>
        <viewAnyTasks>false</viewAnyTasks>
        <includeAssignedSet>true</includeAssignedSet>
        <includeSentSet>false</includeSentSet>
        <includeResponsibleSet>false</includeResponsibleSet>
        <propertyFilters>
            <propertyFilter>
                <property>Assigned user</property>
                <name>Assigned user</name>
                <constraints>
                    <nameConstraint>
                        <operation>IS</operation>
                        <nameType>User type</nameType>
                        <stringValue>{0}</stringValue>
                    </nameConstraint>
                </constraints>
            </propertyFilter>
            <propertyFilter>
                <property>Task type</property>
                <name>Task type</name>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Alert</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Review</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Sign Off</stringValue>
                    </stringConstraint>
                </constraints>
            </propertyFilter>
            <propertyFilter>
                <property>Task status</property>
                <name>Task status</name>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>New</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>New - Overdue</stringValue>
                    </stringConstraint>
                </constraints>
            </propertyFilter>
        </propertyFilters>
    </taskFilter>
    <taskFilter>
        <viewAnyTasks>false</viewAnyTasks>
        <includeAssignedSet>false</includeAssignedSet>
        <includeSentSet>false</includeSentSet>
        <includeResponsibleSet>true</includeResponsibleSet>
        <propertyFilters>
            <propertyFilter>
                <property>Assigned user</property>
                <name>Assigned user</name>
                <constraints>
                    <nameConstraint>
                        <operation>IS</operation>
                        <nameType>User type</nameType>
                        <stringValue>{0}</stringValue>
                    </nameConstraint>
                </constraints>
            </propertyFilter>
            <propertyFilter>
                <property>Task type</property>
                <name>Task type</name>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Alert</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Review</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Sign Off</stringValue>
                    </stringConstraint>
                </constraints>
            </propertyFilter>
            <propertyFilter>
                <property>Task status</property>
                <name>Task status</name>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>In-Progress</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>In-Progress - Overdue</stringValue>
                    </stringConstraint>
                </constraints>
            </propertyFilter>
        </propertyFilters>
    </taskFilter>
</taskFilterSequence>"""

find_tasks_to_close_filter_xml = """
<taskFilterSequence xmlns="http://workflow.services.ewb.idbs.com">
    <taskFilter>
        <viewAnyTasks>false</viewAnyTasks>
        <includeAssignedSet>false</includeAssignedSet>
        <includeSentSet>true</includeSentSet>
        <includeResponsibleSet>false</includeResponsibleSet>
        <propertyFilters>
            <propertyFilter>
                <property>Workflow requester</property>
                <name>Workflow requester</name>
                <constraints>
                    <nameConstraint>
                        <operation>IS</operation>
                        <nameType>User type</nameType>
                        <stringValue>{0}</stringValue>
                    </nameConstraint>
                </constraints>
            </propertyFilter>
            <propertyFilter>
                <property>Task type</property>
                <name>Task type</name>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Alert</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Review</stringValue>
                    </stringConstraint>
                </constraints>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Sign Off</stringValue>
                    </stringConstraint>
                </constraints>
            </propertyFilter>
            <propertyFilter>
                <property>Task status</property>
                <name>Task status</name>
                <constraints>
                    <stringConstraint>
                        <operation>IS</operation>
                        <stringValue>Completed</stringValue>
                    </stringConstraint>
                </constraints>
            </propertyFilter>
        </propertyFilters>
    </taskFilter>
</taskFilterSequence>
"""

class TaskAPILibrary(RestApiLibrary):

    ROBOT_LIBRARY_SCOPE = "GLOBAL"
    ROBOT_LIBRARY_VERSION = __version__

    def remove_users_tasks(self, username):
        self.cancel_assigned_and_responsible_tasks(username)
        self.close_completed_tasks(username)
    
    def cancel_assigned_and_responsible_tasks(self, username):
        xml_payload = find_tasks_to_cancel_filter_xml.format(username)
        task_ids = self._find_task_ids(xml_payload)
        self._cancel_tasks(task_ids)
    
    def close_completed_tasks(self, username):
        xml_payload = find_tasks_to_close_filter_xml.format(username)
        task_ids = self._find_task_ids(xml_payload)
        self._close_tasks(task_ids)

    def _cancel_tasks(self, task_ids):
        if len(task_ids) > 0:
            self._prepare_post(self._get_task_id_sequence(task_ids))
            self.HTTPLib.HTTPLib.POST(root_task_url + "cancel")
            self.check_response_status("cancel_tasks")
    
    def _close_tasks(self, task_ids):
        if len(task_ids) > 0:
            self._prepare_post(self._get_task_id_sequence(task_ids))
            self.HTTPLib.HTTPLib.POST(root_task_url + "close")
            self.check_response_status("cancel_tasks")

    def _find_task_ids(self, payload):
        self._prepare_post(payload)
        self.HTTPLib.HTTPLib.POST(root_task_url + "subset")
        return self._get_task_ids(self.HTTPLib.HTTPLib.get_response_body())

    def _get_task_ids(self, xml):
        dom = parseString(xml)
        task_ids = []
        for node in dom.getElementsByTagName("taskId"):
            task_ids.append(node.childNodes[0].nodeValue)
        return task_ids

    def _get_task_id_sequence(self, task_ids):
        xml_builder = []
        for task_id in task_ids:
            xml_builder.append("<id>{0}</id>".format(task_id))
        return "<ids xmlns=\"http://common.services.ewb.idbs.com\">{0}</ids>".format("".join(xml_builder))

    def _prepare_post(self, payload):
        self._configure_xml_request()
        self.HTTPLib.HTTPLib.set_request_body(payload)
        self.HTTPLib.HTTPLib.next_request_may_not_succeed()
