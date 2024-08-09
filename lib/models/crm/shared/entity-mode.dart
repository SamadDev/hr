
enum EntityMode { None, View, New, Edit, Delete }

int EntityModeToInt(String entityMode) {

  switch (entityMode) {
    case "EntityMode.None":
      return 0;
      break;
    case "EntityMode.View":
      return 1;
      break;
    case "EntityMode.New":
      return 2;
      break;
    case "EntityMode.Edit":
      return 3;
      break;
    case "EntityMode.Delete":
      return 4;
      break;
  }
}


EntityMode IntToEntityMode(int entityMode) {

  switch (entityMode) {
    case 0:
      return EntityMode.None;
      break;
    case 1:
      return EntityMode.View;
      break;
    case 2:
      return EntityMode.New;
      break;
    case 3:
      return EntityMode.Edit;
      break;
    case 4:
      return EntityMode.Delete;
      break;
  }
}
