if (row == -1) {
// Add a new row for the student
final values = [[name, '']];
values[0].addAll(List.filled(values![0].length - 2, ''));
values[0].add(present ? 'Present' : 'Absent');
final body = ValueRange(values: values);
await sheetsApi.spreadsheets.values.append(body, _spreadsheetId, range, valueInputOption: 'USER_ENTERED');
} else {
// Update an existing row for the student
var col = values![0].indexOf(date);
if (col == -1) {
// Add a new column for the date
values[0].add(date);
col = values[0].length - 1;
// Add a new element to each row for the new date column
for (var i = 1; i < values.length; i++) {
values[i].add('');
}
}
// Update the attendance value for the given date
final rowValues = values[row];
rowValues[col] = present ? 'Present' : 'Absent';
final body = ValueRange(values: [rowValues]);
await sheetsApi.spreadsheets.values.update(
body,
_spreadsheetId,
'$sheetName!A${row + 1}:${getColumnName(col + 1)}${row + 1}',
valueInputOption: 'USER_ENTERED',
);
}
}