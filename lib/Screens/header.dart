import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(Header());
}

// ignore: use_key_in_widget_constructors
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Flexible(
      child: Scaffold(
        body: Column(
          children: [
                      //1st header
            Container(      
              // height: 50,
              color: const Color.fromARGB(255, 10, 75, 129),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
              
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    // Left side of the first header
                    Image.asset(
                      '../../assets/logo.png', 
                      height: 40,
                      width: 40,
                    ),
                    const SizedBox(width: 20),
                    Row(
                            /////post login chat it to profil link
                      children:[
                        ElevatedButton(
                          onPressed: ()
                          {
                            Navigator.pushNamed(context, '/signin');  
                          },
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
              ),
            ),
                    // 2nd header
            Container(
              color: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left side of the second header
                  Row(         
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
                    children: [
                          //Navigator -  Navbar 
                      GestureDetector(
                        onTap: () {
                          // Handle hyperlink text press
                        },
                        child: const Text(
                          'Explor',
                          style: TextStyle(color: Colors.white, /*decoration: TextDecoration.underline*/),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          // Handle hyperlink text press
                        },
                        child: const Text(
                          'Tour',
                          style: TextStyle(color: Colors.white, /*decoration: TextDecoration.underline*/),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () {
                          // Handle hyperlink text press
                        },
                        child: const Text(
                          'Aboust Us',
                          style: TextStyle(color: Colors.white, /*decoration: TextDecoration.underline*/),
                        ),
                      ),
                      const SizedBox(width: 20,),
    
                          /////Searchbar
                      Container(
                        width: 200,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: GestureDetector(
                          onTap: (){
                                /////searchbox code
                          },
                          child: const Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  cursorColor: Colors.black,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    // fillColor: Colors.red,
                                    // filled: true,
                                    hintStyle:  TextStyle(color: Colors.black),
                                    border: InputBorder.none,
                                    contentPadding:  EdgeInsets.only(left: 15,top: -17,),
                                  ),
                                ),
                              ),
                              Icon(Icons.search),
                              SizedBox(width: 10,)
                            ],
                          ),
                        )
                      )
                    ],
                  ),
                              // Right side of the second header
                              // Add a circular image
                  const CircleAvatar(
                    radius: 20,   //notification / activity
                    backgroundImage: AssetImage('../../assets/google_logo.png'),
                  ),
                ],  
              )
            ),
          ],
        ),
      ),
    );
  }
}
