class ApiConstant {
  //  Github : https://github.com/gothinkster

  //  official website https://www.realworld.how/

  // static const WEBSITE_OF_THIS_APP = "https://demo.realworld.io/#/";

  /*#1*/ static const BASE_URL = "https://api.realworld.io";
  /*#2*/ static const SUB_URL = "/api";

  /*#3*/ static const LOGIN = BASE_URL + SUB_URL + "/users/login";
  /*#4*/ static const REGISTER = BASE_URL + SUB_URL + "/users";
  /*#5*/ static const PROFILE = BASE_URL + SUB_URL + "/profiles";
  /*#6*/ static const ALL_ARTICLES = BASE_URL + SUB_URL + "/articles";
  /*#7*/ static const YOUR_FEED = BASE_URL + SUB_URL + "/articles/feed";
  /*#8*/ static const ADD_ARTICLE = BASE_URL + SUB_URL + "/articles";
  /*#9*/ static const BASE_COMMENT_URL = BASE_URL + SUB_URL + "/articles";
  /*#10*/ static const END_COMMENT_URL = "/comments";
  /*#11*/ static const MY_ARTICLES = BASE_URL + SUB_URL + "/articles?author=";
  /*#12*/ static const MY_FAVORITE_ARTICLES =
      BASE_URL + SUB_URL + "/articles?favorited=";
  /*#13*/ static const UPDATE_ARTICLE = BASE_URL + SUB_URL + "/articles";
  /*#14*/ static const GET_ARTICLE = BASE_URL + SUB_URL + "/articles";
  /*#15*/ static const UPDATE_USER = BASE_URL + SUB_URL + "/user";
  /*#16*/ static const USER_PROFILE = BASE_URL + SUB_URL + "/user";
  /*#17*/ static const LIKE_ARTICLE = BASE_URL + SUB_URL + "/articles/";
  /*#18*/ static const FOLLOW_USER = BASE_URL + SUB_URL + "/profiles/";
  /*#19*/ static const ALL_POPULAR_TAGS = BASE_URL + SUB_URL + "/tags";
  /*#20*/ static const ARTICLE_BY_TAG = BASE_URL + SUB_URL + "/articles?tag=";

  static const TOKEN =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpheWRlZXBwcEBtYWlsaW5hdG9yLmNvbSIsInVzZXJuYW1lIjoiSmF5ZGVlcHBwIiwiaWF0IjoxNjg0NDk2NTY1LCJleHAiOjE2ODk2ODA1NjV9.TAKbvNlhVw0Qu4P7cuJ3H9shzwKp5QvpRrMUP8P93M0";
}

const String NO_INTERNET =
    "Conduit app is not responding to server. Check your internet connection or try again later.";
