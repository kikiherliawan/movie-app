enum MovieFilter {
  nowPlaying(name: 'now_playing'),
  popular(name: 'popular'),
  topRated(name: 'top_rated'),
  upcoming(name: 'upcoming'),
  favourite(name: '@_favourite'),
  search(name: '@_search');

  const MovieFilter({required this.name});
  final String name;
}
