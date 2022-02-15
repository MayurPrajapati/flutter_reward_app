import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context)
        .textTheme
        .title
        .copyWith(color: Colors.white, fontWeight: FontWeight.bold);
    final normal = Theme.of(context)
        .textTheme
        .title
        .copyWith(fontSize: 16.0, color: Colors.white.withOpacity(0.6));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text('About Us'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 16.0),
              CircleAvatar(
                child: Image.asset('assets/images/logo.png', scale: 1.5),
                backgroundColor: Colors.white,
                radius: 40.0,
              ),
              SizedBox(height: 16.0),
              Text('Chandan Superspeciality and Dental Care',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Text(' A Unit of Chandan Dental Private Limited.',
                  style: TextStyle(fontSize: 13.0, color: Colors.white),
                  textAlign: TextAlign.right),
              SizedBox(height: 16.0),
              Text('VISION', style: title),
              SizedBox(height: 8.0),
              Text(
                  'Chandan Ortho Clinic’s vision is not just limited to treat our patients well, but to make people aware of important aspects of Oral Hygiene as well as prevention measures to avoid Dental problems.',
                  textAlign: TextAlign.center,
                  style: normal),
              SizedBox(height: 16.0),
              Text('MISSION', style: title),
              SizedBox(height: 8.0),
              Text(
                  'Chandan Ortho clinic’s mission is quite obvious, Chandan Ortho clinic organizes many free dental checkup, Oral and Dental Hygiene Awareness camps in all over India to contribute towards our society.',
                  textAlign: TextAlign.center,
                  style: normal),
              SizedBox(height: 16.0),
              Text('OUR CLINIC', style: title),
              SizedBox(height: 8.0),
              Text('''We maintain best hygiene in all dental procedures

Latest equipments and technologies available

Clear aligner Braces this treatment is hardly available in Gujarat

 Introducing lasers in orthodontics''',
                  textAlign: TextAlign.center, style: normal),
              SizedBox(height: 16.0),
              Text('CONTACT US', style: title),
              SizedBox(height: 8.0),
              Text(
                'Address',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8.0),
              Text('48, RC Dutt Rd, Sampatrao Colony, Vadodara, Gujarat 390007',
                  textAlign: TextAlign.center, style: normal),
              SizedBox(height: 8.0),
              Text(
                'Toll Free No',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8.0),
              Text('1800 233 0001 (Mon-Sat,9 a.m. to 8 p.m.)',
                  textAlign: TextAlign.center, style: normal),
              SizedBox(height: 8.0),
              Text(
                'Phone No',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8.0),
              Text('+91 -265-2334806, 2334808, 2334809, 2334810, 2334811',
                  textAlign: TextAlign.center, style: normal),
              SizedBox(height: 8.0),
              Text(
                'Email',
                style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 8.0),
              Text('info@chandanorthodontics.com',
                  textAlign: TextAlign.center, style: normal),
            ],
          ),
        ),
      ),
    );
  }
}
