/*
print("firebaseUser.isEmailVerified" + firebaseUser.isEmailVerified.toString());
print("firebase " + firebaseUser.email);



bool teste = firebaseUser.isEmailVerified;
//firebaseUser.emailVerified;
firebaseUser.sendEmailVerification().then((_) {
  print("email enviado");
}).catchError((error) {
  print("email não foi enviado");
});



snapshot.then((t){
  print(t);
  print(t.documents.isEmpty);
  print(t.documents.length);
  print(t.documents.map((d){

  }));
  t.documents.map((d){
    print(d.data);
  });
  print("depois");
  List<DocumentSnapshot> snapshot = t.documents;
  print(snapshot[0]);
  DocumentSnapshot demonio = snapshot[0];
  print(demonio.documentID);
  print(demonio.data);
  print(snapshot.length);
});


Firestore.instance
    .collection('usuarios')
    .where("celular", isEqualTo: "(28)99887-4184")
    .getDocuments()
    .then((snapshot) {
  if (!snapshot.documents.isEmpty) {
    if(snapshot.documents[0].documentID != firebaseUser.uid){

    }
  }
});



_usuarioController.addListener(onChange(_usuarioController));

  onChange(controller) {
    if (controller.hashCode == _usuarioController.hashCode) {}
  }



*/