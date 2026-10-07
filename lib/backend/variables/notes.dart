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

List<Map<String, dynamic>> saerchedNotes = [];

String sortBy = "";

List<Map<String, dynamic>> sortNotes(
  String sortByCopy,
  List<Map<String, dynamic>> notesDataCopy,
) {
  switch (sortByCopy) {
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

  final List<Map<String, dynamic>> unpinned = [];
  final List<Map<String, dynamic>> pinned = [];
  for (Map<String, dynamic> row in notesDataCopy) {
    if (row["pinned"] != null) {
      pinned.add(row);
    } else {
      unpinned.add(row);
    }
  }
  pinned.sort((b, a) => a["pinned"].compareTo(b["pinned"]));
  return [...pinned, ...unpinned];
}
