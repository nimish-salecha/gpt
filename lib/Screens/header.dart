// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      home:  Header(),
    ),    
);
}

// ignore: use_key_in_widget_constructors
class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dwidth = MediaQuery.of(context).size.width;
    final dheight = MediaQuery.of(context).size.height;
    // print("the width of screen is $dwidth}");
    return  Expanded( 
      // body: SingleChildScrollView(
        child: Container(
          height: dheight,
          width: dwidth,
          child: Column(
            children: [
                        //1st header
              Container(      
                height: dheight * 0.1,
                color: const Color.fromARGB(255, 10, 75, 129),
                padding: const EdgeInsets.fromLTRB(18, 20, 8, 8),
                
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                      // Left side of the first header
                      Image.asset(
                        'assets/logo.png', 
                        height: dheight * 0.1,
                        width: dwidth * 0.1,
                      ),
              
                      // const SizedBox(width: 20),
                      Row(
                              /////post login change it to profil link
                        children:[
                          ElevatedButton(
                            onPressed: ()
                            {
                              Navigator.pushNamed(context, '/signin');  
                            },
                            child: const Text('Sign In'),
                          ),
                          SizedBox(width: dwidth * 0.02),
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
                color: const Color.fromRGBO(76, 175, 80, 1),
                padding: EdgeInsets.symmetric(vertical: dheight * 0.003, horizontal: dwidth*0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side of the second header
                    Row(         
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,  
                      children: [
                            //Navigator -  Navbar 
                        // GestureDetector(
                        //   onTap: () {
                        //     // Handle hyperlink text press
                        //   },
                        //   child: const Text(
                        //     'Explor',
                        //     style: TextStyle(color: Colors.white, /*decoration: TextDecoration.underline*/),
                        //   ),
                        // ),
                        // SizedBox(width: dwidth*0.015,),
                        GestureDetector(
                          onTap: () {
                            // Handle hyperlink text press
                          },
                          child: const Text(
                            'Tour',
                            style: TextStyle(color: Colors.white, /*decoration: TextDecoration.underline*/),
                          ),
                        ),
                        SizedBox(width: dwidth*0.025,),
                        GestureDetector(
                          onTap: () {
                            // Handle hyperlink text press
                          },
                          child: const Text(
                            'Aboust Us',
                            style: TextStyle(color: Colors.white, /*decoration: TextDecoration.underline*/),
                          ),
                        ),
                        SizedBox(width: dwidth*0.04,),
              
                            /////Searchbar
                        Container(
                          width: dwidth*0.45,
                          height: dheight*0.043,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: GestureDetector(
                            onTap: (){
                                  /////searchbox code
                            },
                            child:  Row(
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
                                      contentPadding:  EdgeInsets.only(left: dwidth*0.03,top: -dwidth*0.06,),
                                    ),
                                  ),
                                ),
                                Icon(Icons.search),
                                      //space b/w search icon and searchbox end
                                SizedBox(width: dwidth*0.02,)
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                                // Right side of the second header
                                // Add a circular image
                    const CircleAvatar(
                      radius: 18,   //notification / activity
                      backgroundImage: AssetImage('assets/bell.png'),
                    ),
                  ],  
                )
              ),
            ],
          ),
        ),
      // ),
    );
  }
}