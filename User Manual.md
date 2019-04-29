# 1. Introduction

## 1.1 Purpose of writing

This document aims to introduce registered users to FindU's goals, functions, applicability, hardware requirements and how to install and use FindU.

## 1.2 Project Background

The project is a comp 208 team project. The developer is all members of the 20 team of Comp 208.

## 1.3 References

1.CameraHandlerUtil.swift - from:

   github.com/DejanEnspyra/CameraHandler.swift

   `// theappspace.com`

   `// Created by Dejan Atanasov on 26/06/2017.`

   `// Copyright @ 2017 Dejan Atanasov. All rights reserved.`

2.OHMySQL - from:

   GitHub.com/oleghnidets/OHMySQL

   follow MIT license

3.Apple - Mapkit, CoreData, UIKit, CoreLocation

# 2. Software overview

## 2.1 Software Purpose

FindU's main purpose is to help students find school buildings, public facilities and various activities on campus more easily and quickly.

## 2.2 function

### 2.2.1 Search Facility

Users can search for nearby public facilities by entering the name of the public facilities. In the search results list, users can get the location and specific information of the current facility by clicking on the search results. In facility information, users can view the specific floor location and facility status of the facility. At the same time, the software will plan your route to the current search results and calculate the distance based on your current location or the location you enter.

### 2.2.2 Events

Through Events function, users can find activities they are interested in in in the event list. In addition, users can also enter activity names to find events. After finding the event, the user can click on the time to get the specific information of the time. The specific information of the event includes the time, place and the introduction of the specific activities. sUsers can add content, images, time and place when creating events

### 2.2.3 Register

Visitors can create accounts to become registered users by setting up mail and passwords. Registered users will have comments, score and updates function.

Users need to customize their usernames, enter their mailboxes and a 6-15-bit password, which requires at least one upper case and a number. After creating the account, the user will get a userID as the login credentials.

### 2.2.4 Comments

Registered users can add comments under facility information for each individual public facility. Registered users can report current information about the facility through these reviews. In addition, users can also comment on events to feed back on activities.

### 2.2.5 Credit score

Registered users can score events. The score of each event initiated by the user will become his credit score. Credit score will affect the ranking of sponsored events in the event list.

### 2.2.6 Update

Registered users can publish new event activities by filling in activity information. In addition, registered users can submit updates to public facilities.

# 3. Operating environment

## 3.1 Hardware Requirements

On the hardware side, FindU only adapts to iPhone X or iPhone Xs.

## 3.2 Support software

Operating system: IOS 12.0 and above. 

Database Management System: MySQL Database.

# 4. Instructions for Use

## 4.1 Installation and initialization

Test version: Connect the phone through Xcode and select the iPhone to connect in the running environment. 

<img src="https://roxzmm.github.io/resource/WechatIMG20.jpeg" style = "zoom:20%" />

Then, click the bulid botton.

<img src="https://roxzmm.github.io/resource/WechatIMG21.jpeg" style="zoom:20%" />

Official version: downloaded through app store.

## 4.2 Data background

There are two main sources of the database for this system: field collection and web search. When it comes to the building table in the database, the specific latitude and longitude data were obtained by the system database development team searching for the known global map on the Internet. And the unique building ID number of every building is gained from the official map of the university. In addition, the entire system development team was divided into three groups to collect the detailed facilities information of three blocks of the university. 

For the convenience of the entire system, the database has been uploaded to the server. Furthermore, as for the data maintenance, the relevant responsible team will modify the data in the database in time through the user's comment feedback.

# 5. Operation instructions

## 5.1 Search Facility

a: Click on the "Searh Facility" button

<img src = "https://roxzmm.github.io/resource/s1.jpeg" style = "zoom:10%" />

b: Enter the start location and facility namem

<img src="https://roxzmm.github.io/resource/WechatIMG4.jpeg" style="zoom:10%"/>

c: View route and facility information

<img src="https://roxzmm.github.io/resource/WechatIMG5.jpeg" style="zoom:10%" />

## 5.2 Find Event

a: Click on the "Events" button

<img src="https://roxzmm.github.io/resource/WechatIMG6.jpeg" style = "zoom:10%"/>

b: Click on Event Picture

<img src="https://roxzmm.github.io/resource/WechatIMG7.jpeg" style="zoom:10%" />

c: Click on the "join" button

<img src="https://roxzmm.github.io/resource/WechatIMG9.jpeg" style="zoom:10%"/>

d: View event details

<img src = "https://roxzmm.github.io/resource/WechatIMG10.jpeg" style = "zoom:10%" />

## 5.3 Register

a: Click on the "me" button

<img src="https://roxzmm.github.io/resource/WechatIMG14.jpeg" style="zoom:10%">

b: Fill in your personal information and click Create

<img src="https://roxzmm.github.io/resource/WechatIMG13.jpeg" style="zoom:10%"/>

c: Then you can check your confidence by clicking the "me" button. And user can change Head photo by click photo Botton.

<img src = "https://roxzmm.github.io/resource/WechatIMG18.jpeg" style="zoom:10%"/>

## 5.4 Comment

a: Click on the specific event and then click on the "+" button in the comment below the event.

<img src = "https://roxzmm.github.io/resource/WechatIMG8.jpeg" style="zoom:10%"/>

## 5.5 Add Events

a: Click on the "Events" button

<img src="https://roxzmm.github.io/resource/WechatIMG6.jpeg" style = "zoom:10%"/>

b: Click the "+" button on the event page.

<img src = "https://roxzmm.github.io/resource/WechatIMG11.jpeg" style= " zoom: 10%"/>

c: Fill in the event information and click the "create" button

<img src="https://roxzmm.github.io/resource/WechatIMG12.jpeg" style = "zoom:10%"/>

## 6. List of Program Files and Data Files

The blue FindU folder is the root of program files. The blue Pods folder contains third-party libraries this program used. Under the yellow FindU folder, there are Resource folder, Utility folder, main view controller files, local data model file, and storyboard files. All images used are stored in the folder "Resource". Utility folder contains several files created for general use.

<img src="https://roxzmm.github.io/resource/WechatIMG48.jpeg" style = "zoom:80%"/>