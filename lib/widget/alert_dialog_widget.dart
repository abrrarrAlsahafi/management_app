import 'package:flutter/material.dart';
import 'package:management_app/app_theme.dart';
import 'package:management_app/generated/I10n.dart';
import 'package:management_app/model/folowing.dart';
import 'package:management_app/model/task.dart';
import 'package:management_app/services/emom_api.dart';
import 'package:provider/provider.dart';

class AlertDialogPM extends StatefulWidget {
  final index;
  final title;
  final content;
  final dearection;
  final isMeeting;

  AlertDialogPM(
      {Key key,
      this.title,
      this.content,
      this.dearection,
      this.index,
      this.isMeeting})
      : super(key: key);

  @override
  _AlertDialogPMState createState() => _AlertDialogPMState();
}

class _AlertDialogPMState extends State<AlertDialogPM> {
  final _formKey = GlobalKey<FormState>();
  var massege;
  bool _autoValidate = false;
  bool massgeReseve = false;
  String lognot;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(3.0))),
        contentPadding: EdgeInsets.only(top: 10.0),
        titleTextStyle: MyTheme.bodyText1,
        title: widget.title,
        content: Container(
          decoration: new BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: new BorderRadius.all(new Radius.circular(38.0)),
          ),
          width: MediaQuery.of(context).size.width / 2, //double.minPositive,
          height: MediaQuery.of(context).size.height / 2,
          child: widget.dearection
             // ? Provider.of<UserModel>(context, listen: false).user.isAdmin
                  ? Column(
                      children: [
                        Divider(
                          color: Colors.grey,
                          height: 4.0,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 2.5,
                          child: massgeReseve
                              ? Icon(Icons.check_circle_rounded,
                                  size: 66, color: Color(0xffe9a14e))
                              : ListView.separated(
                                  separatorBuilder: (context, index) => Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Divider(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  shrinkWrap: true,
                                  itemCount: Provider.of<FollowingModel>(
                                          context,
                                          listen: false)
                                      .followList
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      title: Text(Provider.of<FollowingModel>(
                                              context,
                                              listen: false)
                                          .followList[index]
                                          .name),
                                      onTap: ()async {

                                          Provider.of<TaskModel>(context,    listen: false)
                                                  .uidAssigind =
                                              Provider.of<FollowingModel>( context, listen: false) .followList[index]   .id;
                                          await Provider.of<TaskModel>(context, listen: false)
                                              .assginTaskTo(
                                              uid: Provider.of<TaskModel>(context,
                                                  listen: false)
                                                  .uidAssigind,
                                              tid: widget.index.taskId);
                                         // await Provider.of<TaskModel>(context,listen: false).ta;

                                          await Provider.of<TaskModel>(context,listen: false).viewLogNote();


    setState(()  {   massgeReseve = true;  });
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                        ),
                        // SizedBox(height: 12)
                      ],
                    )
                  : alertDialogAddnote()
             // : alertDialogAddnote(),
        ));
  }

  alertDialogAddnote() {
    return massgeReseve
        ? massege == null
            ? Icon(Icons.check_circle_rounded,
                size: 66, color: Color(0xffe9a14e))
            : Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 66, color: Color(0xffe9a14e)),
                  Text(massege, style: MyTheme.kAppTitle)
                ],
              )
        : Column(
            children: [
              Divider(
                color: Colors.grey,
                height: 4.0,
              ),

              Expanded(
                child: Container(
                    child: Form(
                  key: _formKey,
                  //autovalidate: _autoValidate,
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return S.of(context).empty;
                      } else
                        return null;
                    },
                    onSaved: (String value) {
                      lognot = value;
                    },
                    decoration: new InputDecoration(
                      border: InputBorder.none,
                      filled: false,
                      contentPadding: new EdgeInsets.only(
                          left: 10.0, top: 10.0, bottom: 10.0, right: 10.0),
                      hintText: 'Add review...',
                      hintStyle: new TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                )),
                // flex: 2,
              ),
              // dialog bottom
              Container(
                margin: EdgeInsets.zero,
                width: MediaQuery.of(context).size.width,
               // padding: EdgeInsets.only(top: 12.0, bottom: 12.0),
                decoration: BoxDecoration(
                  color: MyTheme.kUnreadChatBG,
                 // borderRadius: BorderRadius.only( bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                ),
                child: TextButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      if (widget.isMeeting == true) {
                        //Note newNote=Note(taskId: widget.index.taskId, body:lognot );
                        _formKey.currentState.save();
                        final replay = await EmomApi().actionDiscreet(
                            sessionId: widget.index.id, discreet: lognot);
                        setState(() {
                          massgeReseve = true;
                        });
                        //print("reddddplay $replay");
                        Navigator.pop(context);
                      }
                      if (widget.isMeeting == null) {
                        // Note newNote=Note(taskId: widget.index.taskId, body:lognot );
                        _formKey.currentState.save();
                        await Provider.of<TaskModel>(context, listen: false)
                            .logNot(mas: lognot, id: widget.index.taskId);
                        await Provider.of<TaskModel>(context,listen: false).viewLogNote();
                        setState(() {
                          massgeReseve = true;
                        });
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
  }
}
