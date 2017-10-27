#!/usr/bin/python
# -*- coding: utf-8 -*-

'''
ZetCode wxPython tutorial

In this example, we create two horizontal
toolbars.

author: Jan Bodnar
website: www.zetcode.com
last modified: September 2011
'''

import wx
from wx.lib.embeddedimage import PyEmbeddedImage
import os


attach = PyEmbeddedImage(
    "iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAQAAAC1+jfqAAAABGdBTUEAAK/INwWK6QAAABl0"
    "RVh0U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAEZSURBVCjPY/jPgB9iEVoqPefl"
    "lFPdNk2GWBUsVpz9ctL1rkcNW/v+59VhKFgkPfP+xI0dF+uC/jPkWCR/Q1MwX2TGvf7Nretr"
    "/UG8BO2I5ygK5olP/dCzpWV+dVAhd+bB+JawrT7ICubIT3nbvaFpVkVqgVDa0diO4CneN91E"
    "4Qpmq0560jW/YXp5XB5nyq2YrqCFno9cJeG+mKk48UHHjLruMu8czuSbkfUBizxeucrDw2GG"
    "ev/71uW1jMVrsq4nPIto8F/g8caFDymgetxbHlVLgDjxnWExPjPdb7sIoYRkk17FywJRECdY"
    "1Xux201nMbSgLufO25qyJUY1yNrzsus9JxkscZHMG+kVcN7jqWueowARkUWiAgBEUvolGfpI"
    "TwAAAABJRU5ErkJggg==")


step_passed = None
failure_message = None
notes = []
file_attachments = []

class Example(wx.Frame):

    def __init__(self, instructions, expected, *args, **kwargs):

        super(Example, self).__init__(style=wx.MINIMIZE_BOX | wx.MAXIMIZE_BOX | wx.RESIZE_BORDER | wx.SYSTEM_MENU |wx.CAPTION | wx.CLIP_CHILDREN, *args, **kwargs)
        self.InitUI(instructions, expected)

    def InitUI(self, instructions, expected):

        self.panel = wx.Panel(self)

        self.toolbar = self.CreateToolBar(style=(wx.TB_HORZ_LAYOUT | wx.TB_TEXT))
        note_button = self.toolbar.AddLabelTool(1, 'Add Note', attach.GetBitmap(), shortHelp='Add Note')
        attach_button = self.toolbar.AddLabelTool(2, 'Attach', attach.GetBitmap(), shortHelp='Attach File')
        self.toolbar.Realize()

        self.Bind(wx.EVT_TOOL, self.OnNote, note_button)
        self.Bind(wx.EVT_TOOL, self.OnAttach, attach_button)


        vbox = wx.BoxSizer(wx.VERTICAL)

        instruction_box = wx.StaticBox(self.panel, -1, "Instructions")
        instruction_bsizer = wx.StaticBoxSizer(instruction_box, wx.VERTICAL)

        instruction_text = wx.StaticText(self.panel, -1, instructions)
        instruction_bsizer.Add(instruction_text, 0, wx.TOP|wx.LEFT, 10)

        vbox.Add(instruction_bsizer, 1, wx.EXPAND|wx.ALL, 10)

        if expected is not None:
            expected_box = wx.StaticBox(self.panel, -1, "Expected")
            expected_bsizer = wx.StaticBoxSizer(expected_box, wx.VERTICAL)

            expected_text = wx.StaticText(self.panel, -1, expected)
            expected_bsizer.Add(expected_text, 0, wx.TOP|wx.LEFT, 10)


            vbox.Add(expected_bsizer, 1, wx.EXPAND|wx.ALL, 10)

        notes_box = wx.StaticBox(self.panel, -1, "Notes")
        self.notes_bsizer = wx.StaticBoxSizer(notes_box, wx.VERTICAL)

        self.notes_text = wx.StaticText(self.panel, -1, "")
        self.notes_bsizer.Add(self.notes_text, 0, wx.TOP|wx.LEFT)


        vbox.Add(self.notes_bsizer, 0, wx.EXPAND|wx.ALL, 10)


        attachment_box = wx.StaticBox(self.panel, -1, "Attachments")
        self.attachment_bsizer = wx.StaticBoxSizer(attachment_box, wx.VERTICAL)

        self.attachment_text = wx.StaticText(self.panel, -1, "")
        self.attachment_bsizer.Add(self.attachment_text, 0, wx.TOP|wx.LEFT)


        vbox.Add(self.attachment_bsizer, 0, wx.EXPAND|wx.ALL, 10)


        button_hbox = wx.BoxSizer(wx.HORIZONTAL)

        pass_button = wx.Button(self.panel, 1, 'Pass')
        self.Bind(wx.EVT_BUTTON, self.OnPass, pass_button)

        fail_button = wx.Button(self.panel, 2, 'Fail')
        self.Bind(wx.EVT_BUTTON, self.OnFail, fail_button)

        button_hbox.Add(pass_button, 1, flag=wx.RIGHT, border=5)
        button_hbox.Add(fail_button, 1)

        vbox.Add(button_hbox, proportion=0, flag=wx.ALIGN_CENTER_HORIZONTAL, border=10)
        vbox.Add((0,20))

        self.panel.SetSizer(vbox)
        self.SetSize((500, 500))
        self.SetTitle('Manual Instruction')
        self.Centre()
        self.Show(True)

    def OnNote(self, e):
        global notes

        dlg = wx.TextEntryDialog(
                self, 'Note to Add:',
                'Add Note', style=wx.TE_MULTILINE|wx.OK|wx.CANCEL)

        if dlg.ShowModal() == wx.ID_OK:
            notes.append(dlg.GetValue())

        dlg.Destroy()
        self.notes_text.SetLabel("\n".join(notes))
        self.panel.Layout()


    def OnAttach(self, e):
        global file_attachments
        dlg = wx.FileDialog(
            self, message="Choose a file to attach",
            defaultDir=os.getcwd(),
            defaultFile="",
            wildcard="All files (*.*)|*.*",
            style=wx.OPEN | wx.MULTIPLE | wx.CHANGE_DIR
            )

        if dlg.ShowModal() == wx.ID_OK:
            paths = dlg.GetPaths()
            for path in paths:
                file_attachments.append(path)

        dlg.Destroy()
        attachment_names = []
        for attachment in file_attachments:
            attachment_names.append(os.path.basename(attachment))
        self.attachment_text.SetLabel("\n".join(attachment_names))
        self.panel.Layout()

    def OnPass(self, e):
        global step_passed

        step_passed = True
        self.Close()

    def OnFail(self, e):
        global step_passed
        global failure_message

        dlg = wx.TextEntryDialog(self, 'Enter failure summary:', 'Failure actual',
                                 style=wx.OK|wx.CANCEL)
        if dlg.ShowModal() == wx.ID_OK:
            failure_message = dlg.GetValue()
            step_passed = False
            self.Close()

    def OnQuit(self, e):
        self.Close()


def show_instructions(instructions):

    ex = wx.App()
    instruction_dialog = Example(instructions, None, None)
    ex.MainLoop()


def show_check(instructions, expected):

    ex = wx.App()
    instruction_dialog = Example(instructions, expected, None)
    ex.MainLoop()


if __name__ == '__main__':
    show_instructions()