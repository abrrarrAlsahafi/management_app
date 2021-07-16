class Sessions {
  int id;
  String name;
  String date;
  String editor;
  String manager;
  List<Members> members;
  List<Topics> topics;
  String stage;

  Sessions(
      {this.id,
      this.name,
      this.date,
      this.editor,
      this.manager,
      this.members,
      this.topics,
      this.stage});

  Sessions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    date = json['date'];
    editor = json['editor'];
    manager = json['manager'];
    if (json['members'] != null) {
      members = []; //new List<Members>();
      json['members'].forEach((v) {
        members.add(new Members.fromJson(v));
      });
    }
    if (json['topics'] != null) {
      topics = []; //new List<Topics>();
      json['topics'].forEach((v) {
        print("v.. $v");
        topics.add(new Topics.fromJson(v));
      });
    }
    stage = json['stage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['date'] = this.date;
    data['editor'] = this.editor;
    data['manager'] = this.manager;
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.topics != null) {
      data['topics'] = this.topics.map((v) => v.toJson()).toList();
    }
    data['stage'] = this.stage;
    return data;
  }
}

class Topics {
  String name;
  String source;
  String abstract;
  String recommendation;

  Topics({this.name, this.source, this.abstract, this.recommendation});

  Topics.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    source = json['source'].toString();
    abstract = json['abstract'];
    recommendation = json['recommendation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['source'] = this.source;
    data['abstract'] = this.abstract;
    data['recommendation'] = this.recommendation;
    return data;
  }
}

class Members {
  String name;
  String attendanceStatus;
  String status;

  Members({this.name, this.attendanceStatus, this.status});

  Members.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    attendanceStatus = json['attendance_status'];
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['attendance_status'] = this.attendanceStatus;
    data['status'] = this.status;
    return data;
  }
}
