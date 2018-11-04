from openalpr import Alpr
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import RPi.GPIO as GPIO
import time
import datetime
import thread
from picamera import PiCamera

first_plate = ""
change = False

cred = credentials.Certificate('fir-ios-a3-firebase-adminsdk-fn90q-0dba86cc71.json')
default_app = firebase_admin.initialize_app(cred, {
    'databaseURL' : 'https://fir-ios-a3.firebaseio.com/'
})

print("Successfully initialize Firebase")
root = db.reference()

#4 places
parks = [0, 0, 0, 0] 
plates = ["", "", "", ""]
times = ["","","",""]
invalids = ["","","",""]
camera = PiCamera()
def capture():
    camera.resolution = (1024, 768)
    camera.start_preview()
    time.sleep(1)
    camera.capture('test_park.jpg')

def update_park():
    # data to save
    global parks 
    for i in range(4):
        data = {
            "state": parks[i],
            "plate": plates[i],
	    "order": times[i],
	    "invalid": invalids[i]
        }    
        results = root.child("park").child("plot_" + str(i)).update(data)    
    
#For server corruption Wrong
def get_park():
    global parks
    results = root.child("park").get()
    #print(results['plot_0']["state"])
    
    for i in range(4): 
        parks[i] = results['plot_'+str(i)]["state"]
        plates[i] = results['plot_'+str(i)]["plate"]
	times[i] = results['plot_'+str(i)]["order"]
	invalids[i] = results['plot_'+str(i)]["invalid"]
	current = datetime.datetime.now()
        if parks[i] == 1:
            time = datetime.datetime.strptime(times[i],"%Y %m %d %H %M %S")
	    elapsed = current - time
	    #print(divmod(elapsed.total_seconds(), 60)[0])
	    if divmod(elapsed.total_seconds(), 60)[0] > 30:
		times[i] = "expired"
		if invalids[i] != "":
		    parks[i] = 2
		else:
		    parks[i] = 0
		temp = plates[i]
		plates[i] = invalids[i]
		invalids[i] = temp
		#print(parks[i])
		return True
    return False

def recognize():
    global first_plate
    first_plate = ""
    alpr = Alpr("auwide", "openalpr/config/openalpr.conf", "openalpr/runtime_data")
    if not alpr.is_loaded():
        print("Error loading OpenALPR")
        sys.exit(1)

    alpr.set_top_n(1)
    #alpr.set_default_region("vic")

    results = alpr.recognize_file("test_park.jpg")

    i = 0
    for plate in results['results']:
        i += 1
        print("Plate #%d" % i)
        print("   %12s %12s" % ("Plate", "Confidence"))
        for candidate in plate['candidates']:
            prefix = "-"
            if candidate['matches_template']:
                prefix = "*"
            print("  %s %12s%12f" % (prefix, candidate['plate'], candidate['confidence']))
            first_plate = candidate['plate']
            
    # Call when completely done to release memory
    alpr.unload()

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.setup(23, GPIO.IN)         #Read output from PIR motion sensor
GPIO.setup(8, GPIO.OUT)         #Red output pin
GPIO.setup(7, GPIO.OUT)         #Yellow output pin
GPIO.setup(26, GPIO.OUT)         #Green output pin

#Run the server:
#while loop 
#when 1:

def update_light():
    if parks[0] == 0:
        print "Empty"
        GPIO.output(7, 0)  #Turn OFF LED
        GPIO.output(8, 0)  #Turn OFF LED
        GPIO.output(26, 1)  #Turn ON LED
    elif parks[0] == 1:
        print "Ordered"
        GPIO.output(7, 1)  #Turn ON LED
        GPIO.output(8, 0)  #Turn OFF LED
        GPIO.output(26, 0)  #Turn OFF LED
    elif parks[0] == 2:
        print "Park"
        GPIO.output(7, 0)  #Turn OFF LED
        GPIO.output(8, 1)  #Turn ON LED
        GPIO.output(26, 0)  #Turn OFF LED
    
while True:
    i=GPIO.input(23)
    expired = get_park()
    update_light()
    if i==0:                 #When output from motion sensor is LOW
        print "No Motion",i
        change = False
    elif i==1:               #When output from motion sensor is HIGH
        print "Motion detected",i
        capture()
        recognize()
#        print(first_plate)
        if parks[0] == 2 and first_plate == "":
#	    print(first_plate)
            GPIO.output(7, 0)  #Turn OFF LED
            GPIO.output(8, 0)  #Turn OFF LED
            GPIO.output(26, 1)  #Turn ON LED
            parks[0] = 0
            plates[0] = ""
	    times[0] = ""
	    invalids[0] = ""
            change = True
        elif (parks[0] == 0 and len(first_plate) >= 6) or (parks[0] == 1 and first_plate == plates[0]):    
            GPIO.output(7, 0)  #Turn OFF LED
            GPIO.output(8, 1)  #Turn ON LED
            GPIO.output(26, 0)  #Turn OFF LED
            parks[0] = 2
            plates[0] = first_plate
	    times[0] = ""
	    invalids[0] = ""
            change = True
        elif parks[0] == 1 and first_plate != plates[0] and len(first_plate) >=6:
            for i in range(5):
                GPIO.output(7, 0)  #Turn OFF LED
                GPIO.output(8, 0)  #Turn ON LED
                GPIO.output(26, 0)  #Turn OFF LED
                time.sleep(0.15)
                GPIO.output(7, 1)  #Turn OFF LED
                GPIO.output(8, 0)  #Turn ON LED
                GPIO.output(26, 0)  #Turn OFF LED
                time.sleep(0.15)
	    invalids[0] = first_plate
            change = True
	else:
	    change = False
    time.sleep(0.1)
    
    if change or expired:
	update_park()

    
