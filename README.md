# ParkingSystem

## Overview

This repository contains code for the ParkingSystem project, which contains both the IOS application and python service with IoT functions to control and monitor the sensors of Raspberry Pi 3. By detecting the movement with the previous status to judge if the parking slot is occupied or not, then update the UI and corresponding functions of IOS application.

**Check the Document.pdf to check more details.**

**Technical Stack:**

- Client Side: **Swift**
  - Server Side: **Firebase + Python**
## Features

- Use openalpr to perform the plate detection task, which is a python library. It is implemented on RPI, and is used after a picture is taken. It contributes the functionality of plate recognition from photos.
  - Ref: https://github.com/openalpr/openalpr
- Use Raspberry Pi 8MP Camera V2 to perform the plate capture task.
- 3 sets of LED + 330 Ω Resistor are responsible for the status display to the user.
- Client side can update the status of a plot from free to ordered by accessing firebase and update its UI according to changes on firebase.
- Meanwhile, the server side will also perform an Bi-direction communication with the firebase. 
