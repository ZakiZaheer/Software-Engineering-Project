
import 'package:task_manager/database_service/supabase_client.dart';

class DatabseService {
  static final _client = SupabaseService.client;

  static Future<void> addTask({required String title,
                                String? description, 
                                String? priority, 
                                String? date , 
                                String? time ,
                                List<String>? subtasks,
                                }) async{
    final task =  await _client.from('tasks').insert(
      {
        'title':title,
        'description':description,
        'priority':priority,
        'date':date,
        'time':time,
      }
    ).select().single();
    
    if(subtasks != null){
     for (var i = 0; i < subtasks.length; i++) {
      // print();
       addSubTask(title: subtasks[i], id: task['id']);
     }
    }
  }

  static Future<void> addSubTask({required String title,required int id}) async{
    await _client.from('sub_tasks').insert({'title':title, 'task_id':id});
    print('Subtask Created: ${title}');
  }

  static Future<List<Map<String,dynamic>>> getSubTasks({required task_id}) async{
    final subtasks = await _client.from('sub_tasks').select().eq('task_id', task_id);
    return subtasks;
  }

  static Future<void> updateTask({required int task_id,
                                String? title,
                                String? description, 
                                String? priority, 
                                String? date , 
                                String? time ,
                                List<String>? subtasks,
                                }) async{
    await _client.from('tasks').update(
      {
        'title':title,
        'description':description,
        'priority':priority,
        'date':date,
        'time':time,
      }
    ).eq('id', task_id);

    await deleteSubTask(task_id: task_id);

    if(subtasks != null){
     for (var i = 0; i < subtasks.length; i++) {
       addSubTask(title: subtasks[i], id: task_id);
     }
    }

  }

 static Future<void> deleteSubTask({required int task_id}) async {
  await _client.from('sub_tasks').delete().eq('task_id', task_id);
  print("all subtasks deleted");
 }

  static Future<void> deleteTask({required task_id}) async {
    await _client.from('tasks').delete().eq('id', task_id);
  }

  static Future<List<Map<String,dynamic>>> getTasks({required String category}) async {
    final tasks;
    if (category == 'all') {
      tasks = await _client.from('tasks').select().order('priority',ascending: false);
    } else {
      tasks = await _client.from('tasks').select().eq('category', category).order('priority',ascending: false);
    }
    
    return tasks;
  }

  static Future<List<String>> getCategories()async{
    final category = await _client.from('tasks').select('category');
    
    final response = category.map((category)=> category['category'] as String).toSet().toList();
    print(response);

    return response;
    
  }
}