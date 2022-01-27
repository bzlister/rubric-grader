import 'package:flapp/menu.dart';
import 'package:flutter/material.dart';

class FileExplorer extends StatelessWidget {
  final FileSystemMode fileSystemMode;

  const FileExplorer.save({Key? key})
      : fileSystemMode = FileSystemMode.save,
        super(key: key);

  const FileExplorer.open({Key? key})
      : fileSystemMode = FileSystemMode.open,
        super(key: key);

  const FileExplorer.export({Key? key})
      : fileSystemMode = FileSystemMode.export,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          fileSystemMode == FileSystemMode.save
              ? "Save"
              : fileSystemMode == FileSystemMode.open
                  ? "Open"
                  : "Export",
        ),
        toolbarHeight: 50,
      ),
      drawer: const Menu(),
      resizeToAvoidBottomInset: true,
      body: Text("WIP"),
    );
  }
}

enum FileSystemMode {
  save,
  open,
  export,
}
