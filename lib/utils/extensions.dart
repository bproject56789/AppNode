extension ModelCheck on Map {
  ///checks if model contains key and its not null
  bool modelCheck(String key) {
    return this.containsKey(key) && this[key] != null;
  }
}
