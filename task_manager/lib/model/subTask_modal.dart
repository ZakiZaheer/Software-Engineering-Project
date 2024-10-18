class SubTask{
  String title;
  bool status;
  int? taskId;

  SubTask({
    required this.title,
    this.status = false,
    this.taskId,
  });

  Map<String,dynamic> toMap(){
    return {
      'title' : title,
      'status' : status == true ? 1 : 0,
      'task_id' : taskId,
    };
  }

  static SubTask fromMap(Map<String,dynamic> map){
    return SubTask(
      title: map['title'],
      status: map['status'] == 1 ? true : false,
      taskId: map['task_id'],
    );
  }

  @override
  String toString() {
    return toMap().toString();
  }

}