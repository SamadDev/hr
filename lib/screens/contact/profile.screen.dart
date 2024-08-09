import 'package:flutter/material.dart';
import 'package:nandrlon/widgets/appbar.widget.dart';
import 'package:nandrlon/widgets/layout.widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfileScreen extends StatefulWidget {
  DoctorProfileScreen({Key key, this.doctor}) : super(key: key);

  final dynamic doctor;

  @override
  _DoctorProfileScreenState createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: AppBarWidget(
        title: "",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile",
                style: TextStyle(
                  color: Color(0xff29304D),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(width: 4, color: Color(0x334F62C0)),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          widget.doctor['image_id'].toString().isNotEmpty
                              ? NetworkImage(
                                  "https://api.dr-online.com/files/${widget.doctor['image_id']}",
                                )
                              : NetworkImage(
                                  "https://i2.wp.com/news.microsoft.com/wp-content/themes/microsoft-news-center-2016/assets/img/default-avatar.png?ssl=1",
                                ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.doctor["name_en"].toString().split(" ")[0],
                        style: TextStyle(
                          color: Color(0xff29304D),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.doctor["name_en"].toString().split(" ")[1],
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.doctor["speciality_names_en"],
                        style: TextStyle(
                          color: Color(0xff8A959E),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 180,
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ActionButton(
                        color: Color(0xff2574FF),
                        iconData: Icons.location_on_outlined,
                        url:
                            'https://www.google.com/maps/search/?api=1&query=${widget.doctor["latlng"]}',
                      ),
                      ActionButton(
                        color: Color(0xff12B2B3),
                        iconData: Icons.call_outlined,
                        url: widget.doctor['name_en'],
                      ),
                      ActionButton(
                        color: Color(0xff1DA1F2),
                        iconData: Icons.mail_outline,
                        url: widget.doctor['name_en'],
                      ),
                    ],
                  ),
                ),
              ),
              ProfileListTile(
                title: "Bio",
                subtitle: widget.doctor['bio_en'],
              ),
              ProfileListTile(
                title: "Phone",
                subtitle: widget.doctor['phone_no'],
              ),
              ProfileListTile(
                title: "Email",
                subtitle: widget.doctor['email'],
              ),
              ProfileListTile(
                title: "Address",
                subtitle: widget.doctor['address_en'] ?? "",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  ActionButton({Key key, this.color, this.iconData, this.url})
      : super(key: key);

  final IconData iconData;
  final Color color;
  final String url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'call not possible';
        }
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: Icon(
          iconData,
          size: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  ProfileListTile({Key key, this.subtitle, this.title}) : super(key: key);

  final dynamic title;
  final dynamic subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          this.title,
          style: TextStyle(
            color: Color(0xff29304D),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          this.subtitle,
          style: TextStyle(
            color: Color(0xffC5C5C5),
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
