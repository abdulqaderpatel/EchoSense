import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:social_media/constants/REST_api.dart';
import 'package:social_media/constants/global.dart';
import 'package:social_media/controllers/authController.dart';
import 'package:social_media/views/components/chat/sender_text.dart';
import 'package:http/http.dart' as http;

import '../../../../controllers/userController.dart';
import '../../../components/chat/receiver_text.dart';

class IndividualChat extends StatefulWidget {
  final dynamic receiverInfo;
  final String combinedId;
  const IndividualChat(
      {required this.combinedId, required this.receiverInfo, key});

  @override
  State<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  AuthController authController = Get.put(AuthController());

  var chatTable = FirebaseFirestore.instance.collection("Chats");
  final messageController = TextEditingController();
  var isLoading = false;
  void getData() async {
    setState(() {
      isLoading = true;
    });
    print(widget.receiverInfo);
    var firebasedata = await chatTable.doc(widget.combinedId).get();
    var userInteractionData = FirebaseFirestore.instance
        .collection("Users")
        .doc(authController.userId.value)
        .collection("messages")
        .doc(widget.receiverInfo["id"]);

    var oppInteractionData = FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.receiverInfo["id"])
        .collection("messages")
        .doc(authController.userId.value);

    if (!firebasedata.exists) {
      await chatTable
          .doc(widget.combinedId)
          .collection("Color")
          .doc(widget.combinedId)
          .set({
        "sender_chat_bubble": "#4075AF",
        "receiver_chat_bubble": "#2A3C4F",
        "sender_chat_text": "#FFEEEE",
        "receiver_chat_text": "#FFEEEE",
        "name_text": "#FFFFFF",
        "top_bar": "#2A3C4F",
        "bottom_bar": "#2A3C4F",
        "background": "#1F282E",
        "icon": "#505E78",
        "text_box": "#19222E",
        "input_text": "#FFFFFF"
      });
      await userInteractionData.set(widget.receiverInfo);
      http.Response res =
          await get("$url/user/details/${authController.userId.value}");
      var currentUserDetails = jsonDecode(res.body);
      await oppInteractionData.set(currentUserDetails);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: isLoading
            ? Center(child: CircularProgressIndicator(color: Colors.grey))
            : SafeArea(
                child: Container(
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: chatTable
                              .doc(widget.combinedId)
                              .collection("Color")
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Container> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = Container(
                                  color: Color(int.parse(client["top_bar"]
                                      .replaceAll("#", "0xFF"))),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () => Navigator.pop(context),
                                        child: const Icon(Icons.arrow_back),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.93,
                                        child: ListTile(
                                            leading: widget.receiverInfo[
                                                        "picture"] ==
                                                    null
                                                ? const CircleAvatar(
                                                    backgroundImage: AssetImage(
                                                        "assets/images/profile_picture.png"))
                                                : CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            widget.receiverInfo[
                                                                "picture"]),
                                                  ),
                                            title: Text(
                                              widget.receiverInfo["name"],
                                              maxLines: 1,
                                              style: TextStyle(
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  color: Color(int.parse(
                                                      client["name_text"]
                                                          .replaceAll(
                                                              "#", "0xFF"))),
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            trailing: PopupMenuButton(
                                                color: Color(int.parse(
                                                    client["name_text"]
                                                        .replaceAll(
                                                            "#", "0xFF"))),
                                                icon: const Icon(Icons.menu),
                                                itemBuilder: (context) {
                                                  return [
                                                    PopupMenuItem(
                                                        onTap: () {},
                                                        child: Text(
                                                          "Edit profile",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        )),
                                                    PopupMenuItem(
                                                      onTap: () async {
                                                        await chatTable
                                                            .doc(widget
                                                                .combinedId)
                                                            .collection("Color")
                                                            .doc(widget
                                                                .combinedId)
                                                            .set({
                                                          "sender_chat_bubble":
                                                              "#4075AF",
                                                          "receiver_chat_bubble":
                                                              "#2A3C4F",
                                                          "sender_chat_text":
                                                              "#FFEEEE",
                                                          "receiver_chat_text":
                                                              "#FFEEEE",
                                                          "name_text":
                                                              "#FFFFFF",
                                                          "top_bar": "#2A3C4F",
                                                          "bottom_bar":
                                                              "#2A3C4F",
                                                          "background":
                                                              "#1F282E",
                                                          "icon": "#505E78",
                                                          "text_box": "#19222E",
                                                          "input_text":
                                                              "#FFFFFF"
                                                        });
                                                      },
                                                      child: Text(
                                                        "Dark theme",
                                                        style: TextStyle(
                                                            color: Color(
                                                              int.parse(client[
                                                                      "background"]
                                                                  .replaceAll(
                                                                      "#",
                                                                      "0xFF")),
                                                            ),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    PopupMenuItem(
                                                      onTap: () async {
                                                        await chatTable
                                                            .doc(widget
                                                                .combinedId)
                                                            .collection("Color")
                                                            .doc(widget
                                                                .combinedId)
                                                            .set({
                                                          "sender_chat_bubble":
                                                              "#29CC55",
                                                          "receiver_chat_bubble":
                                                              "#C7C4CD",
                                                          "name_text":
                                                              "#000000",
                                                          "sender_chat_text":
                                                              "#000000",
                                                          "receiver_chat_text":
                                                              "#FFFFFF",
                                                          "top_bar": "#C7C4CD",
                                                          "bottom_bar":
                                                              "#C7C4CD",
                                                          "background":
                                                              "#FFFFFF",
                                                          "icon": "#6D707E",
                                                          "text_box": "#FFFFFF",
                                                          "input_text":
                                                              "#000000"
                                                        });
                                                      },
                                                      child: Text(
                                                        "Light theme",
                                                        style: TextStyle(
                                                            color: Color(
                                                              int.parse(client[
                                                                      "background"]
                                                                  .replaceAll(
                                                                      "#",
                                                                      "0xFF")),
                                                            ),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    )
                                                  ];
                                                })),
                                      ),
                                    ],
                                  ),
                                );
                                clientWidgets.add(clientWidget);
                              }
                            }
                            return Column(
                              children: clientWidgets,
                            );
                          }),
                      Flexible(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: chatTable
                                .doc(widget.combinedId)
                                .collection("Color")
                                .snapshots(),
                            builder: (context, snapshot) {
                              List<Container> firstClientWidgets = [];
                              if (snapshot.hasData) {
                                final firstClients = snapshot.data?.docs;
                                for (var firstClient in firstClients!) {
                                  final clientWidget = Container(
                                    constraints: BoxConstraints(
                                        minHeight: Get.height * 0.82,
                                        minWidth: Get.width),
                                    padding: EdgeInsets.only(
                                        top: 10,
                                        right: Get.width * 0.025,
                                        left: Get.width * 0.025),
                                    color: Color(int.parse(
                                        firstClient["background"]
                                            .replaceAll("#", "0xFF"))),
                                    child: StreamBuilder<QuerySnapshot>(
                                        stream: chatTable
                                            .doc(widget.combinedId)
                                            .collection("messages")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          List<Row> clientWidgets = [];
                                          if (snapshot.hasData) {
                                            final clients = snapshot.data?.docs;
                                            for (var client in clients!) {
                                              final clientWidget =
                                                  client["sender"] ==
                                                          authController
                                                              .userId.value
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            SenderText(
                                                              message: client[
                                                                  "message"],
                                                              textColor: Color(int
                                                                  .parse(firstClient[
                                                                          "sender_chat_text"]
                                                                      .replaceAll(
                                                                          "#",
                                                                          "0xFF"))),
                                                              bubbleColor: Color(
                                                                  int.parse(firstClient[
                                                                          "sender_chat_bubble"]
                                                                      .replaceAll(
                                                                          "#",
                                                                          "0xFF"))),
                                                            )
                                                          ],
                                                        )
                                                      : Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ReceiverText(
                                                              message: client[
                                                                  "message"],
                                                              textColor: Color(int
                                                                  .parse(firstClient[
                                                                          "receiver_chat_text"]
                                                                      .replaceAll(
                                                                          "#",
                                                                          "0xFF"))),
                                                              bubbleColor: Color(
                                                                  int.parse(firstClient[
                                                                          "receiver_chat_bubble"]
                                                                      .replaceAll(
                                                                          "#",
                                                                          "0xFF"))),
                                                            )
                                                          ],
                                                        );
                                              clientWidgets.add(clientWidget);
                                            }
                                          }
                                          return Column(
                                            children: clientWidgets,
                                          );
                                        }),
                                  );
                                  firstClientWidgets.add(clientWidget);
                                }
                              }
                              return Column(
                                children: firstClientWidgets,
                              );
                            },
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: chatTable
                              .doc(widget.combinedId)
                              .collection("Color")
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Container> clientWidgets = [];
                            if (snapshot.hasData) {
                              final clients = snapshot.data?.docs;
                              for (var client in clients!) {
                                final clientWidget = Container(
                                  color: Color(int.parse(client["bottom_bar"]
                                      .replaceAll("#", "0xFF"))),
                                  padding: EdgeInsets.only(
                                      top: 10, left: 10, right: 10, bottom: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: 32,
                                        color: Color(int.parse(client["icon"]
                                            .replaceAll("#", "0xFF"))),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.05,
                                        width: Get.width * 0.76,
                                        child: TextField(
                                          style: TextStyle(
                                            color: Color(
                                              int.parse(
                                                client["input_text"].replaceAll(
                                                  "#",
                                                  "0xFF",
                                                ),
                                              ),
                                            ),
                                          ),
                                          controller: messageController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                top: 5, left: 10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                            ),
                                            filled: true,
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            hintText: "Type in your text",
                                            fillColor: Color(int.parse(
                                                client["text_box"]
                                                    .replaceAll("#", "0xFF"))),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (messageController
                                              .text.isNotEmpty) {
                                            var time = DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString();
                                            await chatTable
                                                .doc(widget.combinedId)
                                                .collection("messages")
                                                .doc(time)
                                                .set({
                                              "type": "text",
                                              "sender":
                                                  authController.userId.value,
                                              "receiver":
                                                  widget.receiverInfo["id"],
                                              "time": time,
                                              "message": messageController.text
                                            });
                                            messageController.text = "";
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          }
                                        },
                                        child: Icon(
                                          Icons.send,
                                          size: 32,
                                          color: Color(int.parse(client["icon"]
                                              .replaceAll("#", "0xFF"))),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                                clientWidgets.add(clientWidget);
                              }
                            }
                            return Column(
                              children: clientWidgets,
                            );
                          })
                    ],
                  ),
                ),
              ));
  }
}
