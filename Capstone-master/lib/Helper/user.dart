class Member {

   String uid;
   String email;
   String photoUrl;
   String displayName;
   String followers;
   String following;
   String posts;
   String bio;
   String phone;

   Member({this.uid, this.email, this.photoUrl, this.displayName, this.followers, this.following, this.bio, this.posts, this.phone});

    Map toMap(Member member) {
    var data = Map<String, dynamic>();
    data['uid'] = member.uid;
    data['email'] = member.email;
    data['photoUrl'] = member.photoUrl;
    data['displayName'] = member.displayName;
    data['followers'] = member.followers;
    data['following'] = member.following;
    data['bio'] = member.bio;
    data['posts'] = member.posts;
    data['phone'] = member.phone;
    return data;
  }

  Member.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.followers = mapData['followers'];
    this.following = mapData['following'];
    this.bio = mapData['bio'];
    this.posts = mapData['posts'];
    this.phone = mapData['phone']; 
  }
}

