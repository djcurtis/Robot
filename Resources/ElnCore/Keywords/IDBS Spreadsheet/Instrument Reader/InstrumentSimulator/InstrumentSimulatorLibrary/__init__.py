

import time
import socket
import threading
import sys


def worker(self):
    while 1:
        print 'listening ...'
        # wait to accept a connection - blocking call
        self.conn, self.addr = self.s.accept()
        self.connection_status_lock.acquire()
        self.isConnected = True
        self.connection_status_lock.release()
        print 'Connected with ' + self.addr[0] + ':' + str(self.addr[1])


class InstrumentSimulatorLibrary:

    ROBOT_LIBRARY_SCOPE = 'TEST CASE'

    def __init__(self):
        self.instruments = []
        self.ready_to_start_threads = False
        self.num_active_readings_threads = 0
        self.num_reading_threads_lock = threading.Lock()  # Ensures synchronisation across many threads.

    def start_simulator(self, host='', port=50018):
        """This is a deprecated keyword that can only be used for tests that only have a single instrument simulator instance.
        For multiple instruments, use Start New Instrument.
        
        Returns the port number of the simulated instrument that is started.
        If the port given by the user is unavailable, we attempt to change the port until it works.
        
        Example use:
        | Start Simulator   | localhost | 50018 |\n  
        | ${port}=	| Start Simulator	| localhost	| 50018	|\n
        
        The second use is recommended and will send the port of the instrument started to ${port}.
        You can use the ${port} variable to populate your instrument configuration table after starting the Instrument.
        """
        actual_port = self.start_new_simulator(host, port)
        return actual_port

    def send_reading(self, reading_to_send, delay_ms=0):
        """This is a deprecated keyword. Please use Send Reading For Instrument Index."""
        self.instruments[0].p_send_reading(reading_to_send, delay_ms)

    def stop_simulator(self):
        """This is a deprecated keyword. Please use Stop All Simulators."""
        self.instruments[0].p_stop_simulator()

    # UPDATES FOR MULTI SIMULATOR SUPPORT

    def start_new_simulator(self, host='', port=50018):
        """Returns the port number of the simulated instrument that is started.
        If the port given by the user is unavailable, we attempt to change the port until it works.
        
        Example use:
        | Start New Simulator   | localhost | 50018 |\n  
        | ${port}=	| Start New Simulator	| localhost	| 50018	|\n
        
        The second use is recommended and will send the port of the instrument started to ${port}.
        You can use the ${port} variable to populate your instrument configuration table after starting the Instrument.
        
        Each new started simulator will be added to the instruments list and given an index number.
        The index order is 0, 1, 2, 3, etc.
        """
        self.instruments.append(InstrumentSimulatorInstance())
        index = len(self.instruments) - 1
        print "Starting Simulator at index %s" % index
        actual_port = self.instruments[index].p_start_simulator(host, port)
        
        return actual_port
    
    def send_reading_for_instrument_index(self, reading_to_send, instrument_index, delay_ms=0):
        """
        Sends a reading for a specific instrument.
        The index number depends on the order you have started the simulators (they are numbered 0,1,2,3,etc.)
        """
        print "sending instrument readings for instrument at index %s" % instrument_index
        self.instruments[int(instrument_index)].p_send_reading(reading_to_send, delay_ms)
        
    def check_if_instrument_is_connected(self, instrument_index=0):
        """
        Checks if an instrument at a given index is connected. If no index is given, the first instrument is checked
        """
        try:
            print "For instrument at index {}...".format(instrument_index)
            result = self.instruments[int(instrument_index)].isConnected
        except IndexError:
            print "Instrument index given was not found."
            return False

        return result

    def prepare_concurrent_instrument_readings_thread(self, readings_to_send, instrument_index, reading_delay_ms=0):
        """
        Prepares a new thread for sending instrument readings. The thread will not send the readings until the
        Start Concurrent Readings keyword is called.

        Args:
        :param readings_to_send: - A list of the readings to be sent
        :param instrument_index: - The index of the instrument that the user wishes to send the readings from
        :param reading_delay_ms: - The time to pause between each reading.
        """
        t = threading.Thread(target=self._prepare_thread, args=(readings_to_send, instrument_index, reading_delay_ms))
        t.setDaemon(True)
        t.start()

    def _prepare_thread(self, readings_to_send, instrument_index, reading_delay_ms):
        self.num_reading_threads_lock.acquire()
        self.num_active_readings_threads += 1
        self.num_reading_threads_lock.release()
        done = False

        while not done:
            if self.ready_to_start_threads:
                for reading in readings_to_send:
                    try:
                        self.instruments[int(instrument_index)].p_send_reading(reading)
                    except InstrumentReaderException:
                        print("\nInstrument is not connected. Reading cannot be sent.")
                    time.sleep(int(reading_delay_ms) * 0.001)  # Convert to ms
                done = True
                self.num_reading_threads_lock.acquire()
                self.num_active_readings_threads -= 1
                self.num_reading_threads_lock.release()

                # reset the ready to start var when done, otherwise it won't work on a second attempt.
                if self.num_active_readings_threads == 0:
                    print "All concurrent threads finished sending readings."
                    self.ready_to_start_threads = False

    def start_concurrent_readings(self):
        """
        After using Prepare Concurrent Instrument Readings Thread to prepare some threads,
        use this keyword to kick off the readings.
        """
        if self.num_active_readings_threads <= 0:
            raise InstrumentReaderException("No readings prepared. Prepare Concurrent Instrument Readings first!")
        self.ready_to_start_threads = True
        
    def stop_all_simulators(self):
        """
        Stops every simulator that has been started in this test case.
        """
        i = 0
        for instrument in self.instruments:
            print "Stopping instrument at index {}".format(i)
            instrument.p_stop_simulator()
            i += 1


class InstrumentReaderException(Exception):
    def __init__(self, value):
        self.value = value

    def __str__(self):
        return repr(self.value)


class InstrumentSimulatorInstance:

    ROBOT_LIBRARY_SCOPE = 'TEST CASE'

    def __init__(self):
        self.s = ""
        self.conn = ""
        self.isConnected = False
        self.connection_status_lock = threading.Lock()  # Ensures connection status is synchronised across threads.

    def p_start_simulator(self, host='', port=50018):
        """Returns the port number of the simulated instrument that is started.
        If the port given by the user is unavailable, we attempt to change the port until it works.
        
        Example use:
        | Start Simulator   | localhost | 50018 |\n  
        | ${port}=	| Start Simulator	| localhost	| 50018	|\n
        
        The second use is recommended and will send the port of the instrument started to ${port}.
        You can use the ${port} variable to populate your instrument configuration table after starting the Instrument.
        """
        pass
        self.s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        print 'Socket created'
        while 1:
            try:
                self.s.bind((host, int(port)))
                break
            except socket.error as msg:
                if str(msg[0]) == '10048' or str(msg[0]) == '10013':
                    if str(msg[0]) == '10013':
                        print "Port %s is inaccessible, if this error causes the test to fail, there may be " \
                              "insufficient permissions for this user. Attempting to use another port." % port
                    else:
                        # Bind failed because the user tried to use the same port as a recent test
                        # - increment the port number and try again.
                        print 'Port ' + str(port) + ' is either in use or timed out, attempting to use the next port'
                    port += 1
                    if port >= 50518:
                        # Something has gone horribly wrong (or we have 32 tests running close to simultaneously)
                        print 'Bind failed after 500 attempts to change the port. ' \
                              'Error Code: ' + str(msg[0]) + ' Message ' + msg[1]
                        sys.exit()
                else:
                    print 'Bind failed. Error Code: ' + str(msg[0]) + ' Message ' + msg[1]
                    sys.exit()

        print 'Socket bind complete'
    
        self.s.listen(1)
        print 'Socket now listening'

        t = threading.Thread(target=worker, args=(self,))
        t.setDaemon(True)
        t.start()

        t= threading.Thread(target=self.connection_thread, args=())
        t.setDaemon(True)
        t.start()

        return str(port)

    def p_send_reading(self, reading_to_send, delay_ms=0):
        if self.conn:
            full_reading = ""
            try:
                # Make sure the result is a float
                delay_in_secs = 0.001*int(delay_ms)
                for c in reading_to_send:
                    c_int = ord(c)  # These lines exist for
                    c = chr(c_int)  # dealing with extended ASCII characters.
                    self.conn.send(c)
                    full_reading += c
                    time.sleep(delay_in_secs)
                self.conn.send('\n')
                self.conn.send('\r')
                print "Reading sent: {}".format(full_reading)
            except socket.error as msg:
                if str(msg[0]) == '10053':
                    print "Connection has been lost to the server between binding and sending a reading. " \
                          "If this wasn't intentional, something has gone wrong."
                    print "To send more readings, stop and restart the simulator " \
                          "(this will probably need to be on a different port)."
        else:
            raise InstrumentReaderException('Unable to send a reading since no connection has been made.')

    def p_stop_simulator(self):
        if self.s:
            self.s.close()

    # Connection thread constantly updates the instrument state.
    def connection_thread(self):
        while 1:
            if self.conn != "":
                data = self.conn.recv(1)
                if not data:
                    self.connection_status_lock.acquire()
                    self.isConnected = False
                    self.connection_status_lock.release()
                else:
                    self.connection_status_lock.acquire()
                    self.isConnected = True
                    self.connection_status_lock.release()
            time.sleep(0.010)
