from openalpr import Alpr
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import RPi.GPIO as GPIO
import time
import datetime
from picamera import PiCamera

first_plate = ""

cred = credentials.Certificate('fir-ios-a3-firebase-adminsdk-fn90q-0dba86cc71.json')
default_app = firebase_admin.initialize_app(cred, {
    'databaseURL' : 'https://fir-ios-a3.firebaseio.com/'
})

print("Successfully initialize Firebase")
root = db.reference()

# Update a child attribute of the new user.
#new_user.update({'since' : 1799})
camera = PiCamera()
def capture():
    camera.resolution = (1024, 768)
    camera.start_preview()
    time.sleep(1)
    camera.capture('test_out.jpg')

def push_plate():
    # data to save
    global first_plate
    if first_plate != "" and len(first_plate) >=6:
        time = datetime.datetime.now().strftime("%Y %m %d %H %M %S")
        data = {
            "plate": first_plate,
            "time": time,
            "action": "out"
        }
        action = "in"
        lastsnap = root.child("plate").child(first_plate).order_by_key().limit_to_last(1).get()
        if(lastsnap != None):
            action = lastsnap[next(iter(lastsnap))][next(iter(lastsnap[next(iter(lastsnap))]))]["action"]
        # Pass the user's idToken to the push method
        
        if(action != "out"):
            results = root.child("plate").child(first_plate).child(time).push(data)


def recognize():
    global first_plate
    alpr = Alpr("auwide", "openalpr/config/openalpr.conf", "openalpr/runtime_data")
    if not alpr.is_loaded():
        print("Error loading OpenALPR")
        sys.exit(1)

    alpr.set_top_n(1)
    #alpr.set_default_region("vic")

    results = alpr.recognize_file("test_out.jpg")

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

GPIO.output(8, 0)  #Turn OFF LED
GPIO.output(26, 1)  #Turn ON LED
while True:
    i=GPIO.input(23)
    if i==0:                 #When output from motion sensor is LOW
        print "No motion",i
        GPIO.output(8, 0)  #Turn OFF LED
        GPIO.output(26, 1)  #Turn ON LED
    elif i==1:               #When output from motion sensor is HIGH
        print "Motion detected",i
        
        GPIO.output(8, 1)  #Turn ON LED
        GPIO.output(26, 0)  #Turn OFF LED
        
        start = time.time()
        end = time.time()
        while(end - start < 3):
            i=GPIO.input(23)
            if(i==0):
                capture()
                recognize()
                push_plate()
            end = time.time()
            time.sleep(0.1)
        
        #while first_plate == tmp_plate:
            #capture()
            #recognize()
        #GPIO.output(8, 0)  #Turn OFF LED
        #GPIO.output(26, 1)  #Turn ON LED

    time.sleep(0.1)

