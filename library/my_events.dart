import 'package:flutter/material.dart';

class MyEvent extends StatefulWidget {
  const MyEvent({Key? key}) : super(key: key);

  @override
  _MyEventState createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Blueberry's",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ) //TextStyle
                ), //Text
                background: Stack(
                    children: [
                  Center(
                    child: Image.network("https://www.wtcmanila.com.ph/wp-content/uploads/2019/12/Factors-to-Consider-in-Choosing-an-Event-Venue.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Opacity(
                    opacity: 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Colors.grey.shade700,
                            Colors.black,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ), //Images.network
                ]),
              ), //FlexibleSpaceBar
              expandedHeight: 262,
              backgroundColor: Colors.blueAccent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),//<Widget>[]
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      eventDetails(),
                      const SizedBox(height: 10,),
                      userDetails(),
                      const SizedBox(height: 10,),
                      venueDetails(),
                      const SizedBox(height: 10,),
                      catererDetails(),
                    ],
                  ),
                ),
              ),
            ), //SliverAppBar
          ],
        ),
      ),
    );
  }

  Widget eventDetails(){
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("EVENT DETAILS"),
          const SizedBox(height: 10,),
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.event_available, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("Anniversary"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("Ahmedabad"),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("06-03-2022 to 15-03-2022"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userDetails(){
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("BOOKED BY"),
          const SizedBox(height: 10,),
          Container(
            height: 85,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("Jenil Mahyavanshi"),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("1234567890"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget venueDetails(){
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("VENUE DETAILS"),
          const SizedBox(height: 10,),
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("Owner Name"), // owner name
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("venue@email.com"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("1234567890"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.people_rounded, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("capacity"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_rounded, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Line 1"),
                          const Text("Line 2"),
                          const Text("Landmark"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget catererDetails(){
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("CATERER DETAILS"),
          const SizedBox(height: 10,),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("Owner Name"), // owner name
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.email_outlined, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("venue@email.com"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      const Text("1234567890"),
                      const SizedBox(width: 10,),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_rounded, color: Colors.grey.shade700,),
                      const SizedBox(width: 10,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Line 1"),
                          Text("Line 2"),
                          Text("Landmark"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
