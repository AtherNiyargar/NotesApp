// The notes data, which will be  populated by the database,
// at the launch time, will be kept stored in the app runtime.
// This is because, suppose a user sorts the notes according to
// alphabetical order, date created, or modified, then instead
// of calling the database again and again, the user can use this
// one time loaded list.

// However, if the user pull-refresh the app from the home screen,
// then this will be clear and get populated again.
// Still time saving for opening, modifying and sorting.

List<Map<String, dynamic>> notesData = [];

String sortBy = "";

List<Map<String, dynamic>> sortNotes(
  String sortBy,
  List<Map<String, dynamic>> notesDataCopy,
) {
  switch (sortBy) {
    case "created_at_asc":
      notesDataCopy.sort((b, a) => a["created_at"].compareTo(b["created_at"]));
      break;

    case "created_at_desc":
      notesDataCopy.sort((a, b) => a["created_at"].compareTo(b["created_at"]));
      break;

    case "modified_at_asc":
      notesDataCopy.sort(
        (b, a) => a["modified_at"].compareTo(b["modified_at"]),
      );
      break;

    case "modified_at_desc":
      notesDataCopy.sort(
        (a, b) => a["modified_at"].compareTo(b["modified_at"]),
      );
      break;

    case "title_asc":
      notesDataCopy.sort(
        (a, b) => a["title"].toLowerCase().compareTo(b["title"].toLowerCase()),
      );
      break;

    case "title_desc":
      notesDataCopy.sort(
        (b, a) => a["title"].toLowerCase().compareTo(b["title"].toLowerCase()),
      );
      break;
  }
  return notesDataCopy;
}
