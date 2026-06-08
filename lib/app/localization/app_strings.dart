import 'package:flutter/material.dart';

/// Tập trung toàn bộ chuỗi UI và response-code của ứng dụng.
///
/// Cách dùng:
/// ```dart
/// final locale = context.read<LocaleCubit>().state.locale;
/// Text(AppStrings.t(AppStrings.loginTitle, locale));
///
/// // Map response code từ backend
/// final msg = AppStrings.t(apiResponse.message, locale);
/// ```
abstract class AppStrings {
  // ── UI keys ────────────────────────────────────────────────────────────────
  static const String appName = 'app_name';
  static const String language = 'language';

  // Auth
  static const String loginTitle = 'login_title';
  static const String loginSubtitle = 'login_subtitle';
  static const String emailLabel = 'email_label';
  static const String passwordLabel = 'password_label';
  static const String loginButton = 'login_button';
  static const String logoutButton = 'logout_button';
  static const String loggingIn = 'logging_in';

  // Nav / Dashboard
  static const String dashboard = 'dashboard';
  static const String songs = 'songs';
  static const String artists = 'artists';
  static const String albums = 'albums';
  static const String genres = 'genres';
  static const String tags = 'tags';
  static const String playlists = 'playlists';
  static const String users = 'users';

  // Common actions
  static const String add = 'add';
  static const String edit = 'edit';
  static const String delete = 'delete';
  static const String save = 'save';
  static const String cancel = 'cancel';
  static const String confirm = 'confirm';
  static const String search = 'search';
  static const String filter = 'filter';
  static const String reset = 'reset';
  static const String close = 'close';
  static const String back = 'back';
  static const String next = 'next';
  static const String previous = 'previous';
  static const String loading = 'loading';
  static const String retry = 'retry';
  static const String noData = 'no_data';
  static const String unknownError = 'unknown_error';

  // Confirm dialogs
  static const String deleteConfirmTitle = 'delete_confirm_title';
  static const String deleteConfirmContent = 'delete_confirm_content';

  // Table / Pagination
  static const String rowsPerPage = 'rows_per_page';
  static const String totalItems = 'total_items';

  // Albums
  static const String albumInfo = 'album_info';
  static const String coverImage = 'cover_image';
  static const String addAlbum = 'add_album';
  static const String editAlbum = 'edit_album';
  static const String searchAlbum = 'search_album';
  static const String noAlbums = 'no_albums';
  static const String selectArtist = 'select_artist';
  static const String selectSong = 'select_song';
  static const String releaseDate = 'release_date';
  static const String pickDate = 'pick_date';
  static const String tracklist = 'tracklist';
  static const String albumType = 'album_type';
  static const String albumTitle = 'album_title';
  static const String albumDescription = 'album_description';
  static const String songInOtherAlbum = 'song_in_other_album';
  static const String songAlreadyInAlbum = 'song_already_in_album';
  static const String pageOf = 'page_of';
  static const String uploadImage = 'upload_image';
  static const String imageHint = 'image_hint';
  static const String titleRequired = 'title_required';
  static const String atLeastOneArtist = 'at_least_one_artist';
  static const String atLeastOneGenre = 'at_least_one_genre';
  static const String audioFileRequired = 'audio_file_required';
  static const String updateBtn = 'update_btn';
  static const String createBtn = 'create_btn';
  static const String noArtistYet = 'no_artist_yet';

  // Artists
  static const String artistCount = 'artist_count';
  static const String addArtist = 'add_artist';
  static const String editArtist = 'edit_artist';
  static const String createArtist = 'create_artist';
  static const String searchArtist = 'search_artist';
  static const String deleteArtistConfirm = 'delete_artist_confirm';
  static const String noArtists = 'no_artists';
  static const String artistName = 'artist_name';
  static const String country = 'country';
  static const String slug = 'slug';
  static const String actions = 'actions';
  static const String basicInfo = 'basic_info';
  static const String artistNameHint = 'artist_name_hint';
  static const String countryHint = 'country_hint';
  static const String slugHint = 'slug_hint';
  static const String bio = 'bio';
  static const String bioHint = 'bio_hint';
  static const String avatar = 'avatar';
  static const String avatarHint = 'avatar_hint';

  // Genres
  static const String genreCount = 'genre_count';
  static const String addGenre = 'add_genre';
  static const String editGenre = 'edit_genre';
  static const String createGenre = 'create_genre';
  static const String searchGenre = 'search_genre';
  static const String deleteGenreConfirm = 'delete_genre_confirm';
  static const String noGenres = 'no_genres';
  static const String genreName = 'genre_name';
  static const String genreNameLabel = 'genre_name_label';
  static const String genreNameHint = 'genre_name_hint';
  static const String genreSlugHint = 'genre_slug_hint';
  static const String coverUrl = 'cover_url';
  static const String coverUrlHint = 'cover_url_hint';
  static const String descriptionHint = 'description_hint';
  static const String noSlug = 'no_slug';
  static const String noDescription = 'no_description';
  static const String genreInfo = 'genre_info';
  static const String uploadCover = 'upload_cover';

  // Lyrics
  static const String lyrics = 'lyrics';
  static const String lyricsSubtitle = 'lyrics_subtitle';
  static const String languageLabel = 'language_label';
  static const String languageHint = 'language_hint';
  static const String syncedLyricsTitle = 'synced_lyrics_title';
  static const String syncedLyricsSubtitleActive = 'synced_lyrics_subtitle_active';
  static const String syncedLyricsSubtitleInactive = 'synced_lyrics_subtitle_inactive';
  static const String deleteLyrics = 'delete_lyrics';
  static const String updateLyrics = 'update_lyrics';
  static const String createLyrics = 'create_lyrics';
  static const String plainLyricsLabel = 'plain_lyrics_label';
  static const String plainLyricsHint = 'plain_lyrics_hint';
  static const String syncedLinesTitle = 'synced_lines_title';
  static const String addLine = 'add_line';
  static const String noSyncedLines = 'no_synced_lines';
  static const String insertLineAfter = 'insert_line_after';
  static const String deleteLine = 'delete_line';
  static const String lineTextLabel = 'line_text_label';
  static const String lineTextHint = 'line_text_hint';
  static const String deleteLyricsConfirmTitle = 'delete_lyrics_confirm_title';
  static const String deleteLyricsConfirmContent = 'delete_lyrics_confirm_content';
  static const String validationSyncedLineRequired = 'validation_synced_line_required';
  static const String validationStartFormatError = 'validation_start_format_error';
  static const String validationEndFormatError = 'validation_end_format_error';

  // Playlists
  static const String deletePlaylistConfirm = 'delete_playlist_confirm';
  static const String playlistCount = 'playlist_count';
  static const String addPlaylist = 'add_playlist';
  static const String editPlaylist = 'edit_playlist';
  static const String searchPlaylist = 'search_playlist';
  static const String playlistInfo = 'playlist_info';
  static const String playlistNameLabel = 'playlist_name_label';
  static const String playlistNameHint = 'playlist_name_hint';
  static const String activeStatus = 'active_status';
  static const String hiddenStatus = 'hidden_status';
  static const String playlistActiveDesc = 'playlist_active_desc';
  static const String playlistHiddenDesc = 'playlist_hidden_desc';
  static const String playlistDescHint = 'playlist_desc_hint';
  static const String songList = 'song_list';
  static const String addSong = 'add_song';
  static const String reorderSongsDesc = 'reorder_songs_desc';
  static const String emptyPlaylist = 'empty_playlist';
  static const String removeFromPlaylist = 'remove_from_playlist';
  static const String addSongToPlaylist = 'add_song_to_playlist';
  static const String searchSong = 'search_song';
  static const String noMatchingSongs = 'no_matching_songs';
  static const String noPlaylists = 'no_playlists';
  static const String playlist = 'playlist';
  static const String updated = 'updated';
  static const String songsCount = 'songs_count';

  // Songs UI
  static const String addSongNew = 'add_song_new';
  static const String editSong = 'edit_song';
  static const String noSongsYet = 'no_songs_yet';
  static const String clickAddSongStart = 'click_add_song_start';
  static const String songLibraryCount = 'song_library_count';
  static const String searchSongHint = 'search_song_hint';
  static const String deleteSongConfirm = 'delete_song_confirm';
  static const String songInfo = 'song_info';
  static const String songTitleLabel = 'song_title_label';
  static const String songTitleHint = 'song_title_hint';
  static const String noAlbumAssigned = 'no_album_assigned';
  static const String trackNumberLabel = 'track_number_label';
  static const String mustBeInteger = 'must_be_integer';
  static const String selectGenreHint = 'select_genre_hint';
  static const String selectTagHint = 'select_tag_hint';
  static const String onlyEditActive = 'only_edit_active';
  static const String media = 'media';
  static const String uploadCoverImage = 'upload_cover_image';
  static const String replaceAudioFile = 'replace_audio_file';
  static const String uploadAudioFile = 'upload_audio_file';
  static const String requiredOnCreate = 'required_on_create';
  static const String apiDataSourceHint = 'api_data_source_hint';
  static const String lyricsSavedSuccess = 'lyrics_saved_success';
  static const String lyricsDeletedSuccess = 'lyrics_deleted_success';
  static const String lyricsErrorPrefix = 'lyrics_error_prefix';
  static const String songCreatedLyricsFailed = 'song_created_lyrics_failed';
  static const String loadAlbumsError = 'load_albums_error';
  static const String untitledAlbum = 'untitled_album';
  static const String inactiveStatus = 'inactive_status';
  static const String songColumnHeader = 'song_column_header';
  static const String artistColumnHeader = 'artist_column_header';
  static const String genreColumnHeader = 'genre_column_header';
  static const String durationColumnHeader = 'duration_column_header';
  static const String statusColumnHeader = 'status_column_header';
  static const String actionsColumnHeader = 'actions_column_header';

  // Tags UI
  static const String addTag = 'add_tag';
  static const String editTag = 'edit_tag';
  static const String deleteTagConfirm = 'delete_tag_confirm';
  static const String tagsCount = 'tags_count';
  static const String searchTag = 'search_tag';
  static const String all = 'all';
  static const String mood = 'mood';
  static const String theme = 'theme';
  static const String activity = 'activity';
  static const String era = 'era';
  static const String tagInfo = 'tag_info';
  static const String tagName = 'tag_name';
  static const String tagNameHint = 'tag_name_hint';
  static const String colorHexLabel = 'color_hex_label';
  static const String colorHexHint = 'color_hex_hint';
  static const String invalidHexColor = 'invalid_hex_color';
  static const String noTagsYet = 'no_tags_yet';
  static const String tagTypeLabel = 'tag_type_label';
  static const String tagColorLabel = 'tag_color_label';

  // Users UI
  static const String accountsCount = 'accounts_count';
  static const String searchUserHint = 'search_user_hint';
  static const String allRoles = 'all_roles';
  static const String allStatuses = 'all_statuses';
  static const String bannedStatus = 'banned_status';
  static const String roleLabel = 'role_label';
  static const String statusLabel = 'status_label';
  static const String userDetailTitle = 'user_detail_title';
  static const String userDetailLabel = 'user_detail_label';
  static const String loadUserDetailError = 'load_user_detail_error';
  static const String displayNameLabel = 'display_name_label';
  static const String banReasonLabel = 'ban_reason_label';
  static const String bannedAtLabel = 'banned_at_label';
  static const String lastLoginLabel = 'last_login_label';
  static const String createdAtLabel = 'created_at_label';
  static const String banAccountLabel = 'ban_account_label';
  static const String unbanAccountLabel = 'unban_account_label';
  static const String banReasonHint = 'ban_reason_hint';
  static const String banReasonRequired = 'ban_reason_required';
  static const String banButtonLabel = 'ban_button_label';
  static const String unbanAccountTitle = 'unban_account_title';
  static const String unbanAccountConfirm = 'unban_account_confirm';
  static const String noUsersFound = 'no_users_found';
  static const String roleUserLabel = 'role_user_label';
  static const String roleContentManagerLabel = 'role_content_manager_label';
  static const String roleAdminLabel = 'role_admin_label';

  // Activity Log UI
  static const String activityLog = 'activity_log';
  static const String activityLogCount = 'activity_log_count';
  static const String activityLogSearchHint = 'activity_log_search_hint';
  static const String activityLogAction = 'activity_log_action';
  static const String allActions = 'all_actions';
  static const String activityLogActor = 'activity_log_actor';
  static const String activityLogResource = 'activity_log_resource';
  static const String activityLogResourceName = 'activity_log_resource_name';
  static const String activityLogFrom = 'activity_log_from';
  static const String activityLogTo = 'activity_log_to';

  // Statistics UI
  static const String statistics = 'statistics';
  static const String statsSubtitle = 'stats_subtitle';
  static const String statsPlaysDaily = 'stats_plays_daily';
  static const String statsTopSongs = 'stats_top_songs';
  static const String statsTopArtists = 'stats_top_artists';
  static const String statsDau = 'stats_dau';
  static const String statsDauSubtitle = 'stats_dau_subtitle';
  static const String statsMau = 'stats_mau';
  static const String statsMauSubtitle = 'stats_mau_subtitle';


  // ── Response code keys (từ backend, dùng trực tiếp làm key) ───────────────
  // Success
  static const String successOk = 'success.ok';

  // Auth / Permission
  static const String errUnauthorized = 'error.unauthorized';
  static const String errUnauthorizedInvalidCredentials =
      'error.unauthorized.invalid_credentials';
  static const String errUnauthorizedInvalidToken =
      'error.unauthorized.invalid_token';
  static const String errAccountLocked = 'error.account_locked';
  static const String errAuthCurrentPasswordInvalid =
      'error.auth.current_password_invalid';
  static const String errForbidden = 'error.forbidden';
  static const String errForbiddenPlaylistAccess =
      'error.forbidden.playlist_access';

  // Not found
  static const String errNotFound = 'error.not_found';
  static const String errNotFoundUser = 'error.not_found.user';
  static const String errNotFoundSong = 'error.not_found.song';
  static const String errNotFoundArtist = 'error.not_found.artist';
  static const String errNotFoundAlbum = 'error.not_found.album';
  static const String errNotFoundGenre = 'error.not_found.genre';
  static const String errNotFoundPlayHistory = 'error.not_found.play_history';
  static const String errNotFoundPlaylist = 'error.not_found.playlist';
  static const String errNotFoundPlaylistSong = 'error.not_found.playlist_song';
  static const String errNotFoundSystemPlaylist =
      'error.not_found.system_playlist';
  static const String errNotFoundSystemPlaylistSong =
      'error.not_found.system_playlist_song';
  static const String errNotFoundFavorite = 'error.not_found.favorite';
  static const String errNotFoundLyrics = 'error.not_found.lyrics';
  static const String errNotFoundTag = 'error.not_found.tag';

  // Conflict
  static const String errConflict = 'error.conflict';
  static const String errConflictEmailExists = 'error.conflict.email_exists';
  static const String errConflictFavoriteExists =
      'error.conflict.favorite_exists';
  static const String errConflictPlaylistSongExists =
      'error.conflict.playlist_song_exists';
  static const String errConflictSystemPlaylistSongExists =
      'error.conflict.system_playlist_song_exists';
  static const String errConflictLyricsExists = 'error.conflict.lyrics_exists';
  static const String errConflictSlugExists = 'error.conflict.slug_exists';

  // Bad request / Business rule
  static const String errBadRequest = 'error.bad_request';
  static const String errBadRequestInvalidBody =
      'error.bad_request.invalid_body';
  static const String errBadRequestTypeMismatch =
      'error.bad_request.type_mismatch';
  static const String errQueryRequired = 'error.query.required';
  static const String errSongAudioRequired = 'error.song.audio_required';
  static const String errSongAudioSourceNotFound =
      'error.song.audio_source_not_found';
  static const String errTagIdsRequired = 'error.tag.ids_required';
  static const String errPlaylistVisibilityInvalid =
      'error.playlist.visibility_invalid';
  static const String errPlaylistNameRequired = 'error.playlist.name_required';
  static const String errPlaylistNameTooLong = 'error.playlist.name_too_long';
  static const String errTagNameExists = 'error.tag.name_exists';
  static const String errTagNameRequired = 'error.tag.name_required';
  static const String errTagTypeRequired = 'error.tag.type_required';
  static const String errTagTypeInvalid = 'error.tag.type_invalid';
  static const String errPlaylistReorderInvalid =
      'error.playlist.reorder.invalid';
  static const String errSystemPlaylistReorderInvalid =
      'error.system_playlist.reorder.invalid';
  static const String errLyricsSyncedInvalid = 'error.lyrics.synced.invalid';

  // System / Storage
  static const String errStorageOperationFailed =
      'error.storage.operation_failed';
  static const String errInternal = 'error.internal';

  // Validation codes
  static const String validationNotBlank = 'validation.not_blank';
  static const String validationNotNull = 'validation.not_null';
  static const String validationNotEmpty = 'validation.not_empty';
  static const String validationSizeMin = 'validation.size.min';
  static const String validationSizeMax = 'validation.size.max';
  static const String validationSizeRange = 'validation.size.range';
  static const String validationEmail = 'validation.email';
  static const String validationPattern = 'validation.pattern';
  static const String validationPositiveOrZero = 'validation.positive_or_zero';
  static const String validationInvalidFormat = 'validation.invalid_format';
  static const String validationTypeMismatch = 'validation.type_mismatch';
  static const String validationRequired = 'validation.required';

  // ── Translations ───────────────────────────────────────────────────────────

  static const Map<String, String> _vi = {
    // ── UI ──────────────────────────────────────────────────────────────────
    'app_name': 'Ondas Admin',
    'language': 'Ngôn ngữ',

    // Auth
    'login_title': 'Đăng nhập',
    'login_subtitle': 'Chào mừng trở lại, vui lòng đăng nhập để tiếp tục.',
    'email_label': 'Email',
    'password_label': 'Mật khẩu',
    'login_button': 'Đăng nhập',
    'logout_button': 'Đăng xuất',
    'logging_in': 'Đang đăng nhập...',

    // Nav / Dashboard
    'dashboard': 'Tổng quan',
    'songs': 'Bài hát',
    'artists': 'Nghệ sĩ',
    'albums': 'Album',
    'genres': 'Thể loại',
    'tags': 'Tag / Tâm trạng',
    'playlists': 'Playlist hệ thống',
    'users': 'Người dùng',

    // Common actions
    'add': 'Thêm mới',
    'edit': 'Chỉnh sửa',
    'delete': 'Xoá',
    'save': 'Lưu',
    'cancel': 'Huỷ',
    'confirm': 'Xác nhận',
    'search': 'Tìm kiếm',
    'filter': 'Lọc',
    'reset': 'Đặt lại',
    'close': 'Đóng',
    'back': 'Quay lại',
    'next': 'Tiếp theo',
    'previous': 'Trước',
    'loading': 'Đang tải...',
    'retry': 'Thử lại',
    'no_data': 'Không có dữ liệu',
    'unknown_error': 'Đã xảy ra lỗi không xác định',

    // Confirm dialogs
    'delete_confirm_title': 'Xác nhận xoá',
    'delete_confirm_content': 'Bạn có chắc chắn muốn xoá mục này không?',

    // Table / Pagination
    'rows_per_page': 'Hàng mỗi trang',
    'total_items': 'Tổng số mục',

    // Albums
    'album_info': 'Thông tin album',
    'cover_image': 'Ảnh bìa',
    'add_album': 'Thêm album',
    'edit_album': 'Chỉnh sửa album',
    'search_album': 'Tìm kiếm album...',
    'no_albums': 'Không có album nào.',
    'select_artist': 'Chọn nghệ sĩ',
    'select_song': 'Chọn bài hát',
    'release_date': 'Ngày phát hành',
    'pick_date': 'Chọn ngày...',
    'tracklist': 'Bài hát (Tracklist)',
    'album_type': 'Loại album',
    'album_title': 'Tiêu đề *',
    'album_description': 'Mô tả',
    'song_in_other_album': 'Đã thuộc album khác',
    'song_already_in_album': 'Đã có album',
    'page_of': 'Trang',
    'upload_image': 'Tải ảnh lên',
    'image_hint': 'PNG, JPG hoặc WEBP. Tối đa 5 MB.',
    'title_required': 'Không được để trống',
    'at_least_one_artist': 'Vui lòng chọn ít nhất 1 nghệ sĩ.',
    'at_least_one_genre': 'Vui lòng chọn ít nhất 1 thể loại.',
    'audio_file_required': 'Vui lòng chọn file audio khi tạo bài hát mới.',
    'update_btn': 'Cập nhật',
    'create_btn': 'Tạo mới',
    'no_artist_yet': 'Chưa có nghệ sĩ',

    // Artists
    'artist_count': 'nghệ sĩ',
    'add_artist': 'Thêm nghệ sĩ',
    'edit_artist': 'Chỉnh sửa nghệ sĩ',
    'create_artist': 'Thêm nghệ sĩ mới',
    'search_artist': 'Tìm kiếm nghệ sĩ...',
    'delete_artist_confirm': 'Bạn có chắc muốn xóa nghệ sĩ "{name}"? Hành động này không thể hoàn tác.',
    'no_artists': 'Không có nghệ sĩ nào.',
    'artist_name': 'Tên nghệ sĩ',
    'country': 'Quốc gia',
    'slug': 'Slug',
    'actions': 'Hành động',
    'basic_info': 'Thông tin cơ bản',
    'artist_name_hint': 'VD: Sơn Tùng M-TP',
    'country_hint': 'VD: Việt Nam',
    'slug_hint': 'son-tung-m-tp',
    'bio': 'Tiểu sử',
    'bio_hint': 'Mô tả về nghệ sĩ...',
    'avatar': 'Ảnh đại diện',
    'avatar_hint': 'PNG, JPG hoặc WEBP. Tối đa 2 MB.',

    // Genres
    'genre_count': 'thể loại',
    'add_genre': 'Thêm thể loại',
    'edit_genre': 'Chỉnh sửa thể loại',
    'create_genre': 'Thêm thể loại mới',
    'search_genre': 'Tìm kiếm thể loại...',
    'delete_genre_confirm': 'Bạn có chắc muốn xóa thể loại "{name}"?',
    'no_genres': 'Không có thể loại nào.',
    'genre_name': 'Tên thể loại',
    'genre_name_label': 'Tên thể loại *',
    'genre_name_hint': 'VD: V-Pop',
    'genre_slug_hint': 'v-pop',
    'cover_url': 'Cover URL',
    'cover_url_hint': 'https://...',
    'description_hint': 'Mô tả ngắn về thể loại...',
    'no_slug': 'Không có slug',
    'no_description': 'Không có mô tả',
    'genre_info': 'Thông tin thể loại',
    'upload_cover': 'Tải ảnh bìa',

    // Lyrics
    'lyrics': 'Lyrics',
    'lyrics_subtitle': 'Cập nhật lời bài hát (plain text hoặc synced).',
    'language_label': 'Ngôn ngữ',
    'language_hint': 'vd: vi, en',
    'synced_lyrics_title': 'Lời bài hát động (Synced Lyrics)',
    'synced_lyrics_subtitle_active': 'Nhập lời có timestamp cho từng dòng',
    'synced_lyrics_subtitle_inactive': 'Nhập lời dạng plain text',
    'delete_lyrics': 'Xoá Lyrics',
    'update_lyrics': 'Cập nhật Lyrics',
    'create_lyrics': 'Tạo Lyrics',
    'plain_lyrics_label': 'Lời bài hát',
    'plain_lyrics_hint': 'Nhập lời bài hát dạng plain text...',
    'synced_lines_title': 'Danh sách dòng synced',
    'add_line': 'Thêm dòng',
    'no_synced_lines': 'Chưa có dòng nào. Nhấn "Thêm dòng" để bắt đầu.',
    'insert_line_after': 'Chèn dòng sau dòng này',
    'delete_line': 'Xoá dòng này',
    'line_text_label': 'Lời dòng {num}',
    'line_text_hint': 'Nhập lời...',
    'delete_lyrics_confirm_title': 'Xác nhận xoá',
    'delete_lyrics_confirm_content': 'Bạn có chắc muốn xoá lyrics của bài hát này?',
    'validation_synced_line_required': 'Mỗi dòng synced phải có nội dung.',
    'validation_start_format_error': 'Dòng {num}: Start phải đúng định dạng mm:ss (vd 01:18.5).',
    'validation_end_format_error': 'Dòng {num}: End phải đúng định dạng mm:ss (vd 01:18.5).',

    // Playlists
    'delete_playlist_confirm': 'Bạn có chắc muốn xóa playlist "{name}"?',
    'playlist_count': 'playlist hệ thống',
    'add_playlist': 'Thêm system playlist',
    'edit_playlist': 'Sửa System Playlist',
    'search_playlist': 'Tìm system playlist...',
    'playlist_info': 'Thông tin Playlist',
    'playlist_name_label': 'Tên playlist *',
    'playlist_name_hint': 'VD: Top hits',
    'active_status': 'Đang hoạt động',
    'hidden_status': 'Đã ẩn',
    'playlist_active_desc': 'Playlist xuất hiện cho user.',
    'playlist_hidden_desc': 'Playlist bị ẩn với user.',
    'playlist_desc_hint': 'Mô tả về playlist...',
    'song_list': 'Danh sách bài hát',
    'add_song': 'Thêm bài',
    'reorder_songs_desc': 'Kéo thả để đổi thứ tự. {count} bài.',
    'empty_playlist': 'Chưa có bài hát nào trong playlist.',
    'remove_from_playlist': 'Xóa khỏi playlist',
    'add_song_to_playlist': 'Thêm bài vào playlist',
    'search_song': 'Tìm bài hát...',
    'no_matching_songs': 'Không có bài hát phù hợp.',
    'no_playlists': 'Chưa có playlist nào',
    'playlist': 'Playlist',
    'updated': 'Cập nhật',
    'songs_count': 'bài hát',

    // Songs UI
    'add_song_new': 'Thêm bài hát mới',
    'edit_song': 'Chỉnh sửa bài hát',
    'no_songs_yet': 'Chưa có bài hát nào',
    'click_add_song_start': 'Nhấn "Thêm bài hát" để bắt đầu',
    'song_library_count': '{count} bài hát trong thư viện',
    'search_song_hint': 'Tìm kiếm bài hát...',
    'delete_song_confirm': 'Bạn có chắc muốn xóa bài hát "{name}"?',
    'song_info': 'Thông tin bài hát',
    'song_title_label': 'Tiêu đề *',
    'song_title_hint': 'VD: Nơi này có anh',
    'no_album_assigned': 'Không gán album',
    'track_number_label': 'Track number',
    'must_be_integer': 'Phải là số nguyên',
    'select_genre_hint': 'Chọn thể loại',
    'select_tag_hint': 'Chọn tag (tùy chọn)',
    'only_edit_active': '(Chỉ sửa khi edit)',
    'media': 'Media',
    'upload_cover_image': 'Tải ảnh cover',
    'replace_audio_file': 'Thay file audio',
    'upload_audio_file': 'Tải file audio *',
    'required_on_create': 'Bắt buộc khi tạo mới',
    'api_data_source_hint': 'Nguồn dữ liệu artist, genre, album, tag được tải từ API.',
    'lyrics_saved_success': 'Đã lưu lyrics.',
    'lyrics_deleted_success': 'Đã xoá lyrics.',
    'lyrics_error_prefix': 'Lỗi lyrics: {msg}',
    'song_created_lyrics_failed': '{msg}. Nhưng tạo lyrics thất bại: {lyricsMsg}',
    'load_albums_error': 'Không thể tải danh sách album',
    'untitled_album': 'Album không tiêu đề',
    'inactive_status': 'Không hoạt động',
    'song_column_header': 'BÀI HÁT',
    'artist_column_header': 'NGHỆ SĨ',
    'genre_column_header': 'THỂ LOẠI',
    'duration_column_header': 'THỜI LƯỢNG',
    'status_column_header': 'TRẠNG THÁI',
    'actions_column_header': 'HÀNH ĐỘNG',

    // Tags UI
    'add_tag': 'Thêm tag',
    'edit_tag': 'Sửa tag',
    'delete_tag_confirm': 'Bạn có chắc muốn xóa tag "{name}"?',
    'tags_count': 'tag',
    'search_tag': 'Tìm tag...',
    'all': 'Tất cả',
    'mood': 'Tâm trạng (Mood)',
    'theme': 'Chủ đề (Theme)',
    'activity': 'Hoạt động (Activity)',
    'era': 'Thời kỳ (Era)',
    'tag_info': 'Thông tin Tag',
    'tag_name': 'Tên tag',
    'tag_name_hint': 'VD: Vui vẻ',
    'color_hex_label': 'Màu Hex',
    'color_hex_hint': 'VD: #FF9900',
    'invalid_hex_color': 'Định dạng không hợp lệ (#RRGGBB)',
    'no_tags_yet': 'Chưa có tag nào',
    'tag_type_label': 'Loại',
    'tag_color_label': 'Màu sắc',

    // Users UI
    'accounts_count': 'tài khoản',
    'search_user_hint': 'Tìm theo email hoặc tên hiển thị...',
    'all_roles': 'Tất cả vai trò',
    'all_statuses': 'Tất cả trạng thái',
    'banned_status': 'Bị khóa',
    'role_label': 'Vai trò',
    'status_label': 'Trạng thái',
    'user_detail_title': 'Chi tiết người dùng',
    'user_detail_label': 'Chi tiết',
    'load_user_detail_error': 'Không thể tải thông tin người dùng.',
    'display_name_label': 'Tên hiển thị',
    'ban_reason_label': 'Lý do khóa',
    'banned_at_label': 'Khóa lúc',
    'last_login_label': 'Đăng nhập gần',
    'created_at_label': 'Tạo lúc',
    'ban_account_label': 'Khóa tài khoản',
    'unban_account_label': 'Mở khóa',
    'ban_reason_hint': 'Nhập lý do khóa tài khoản...',
    'ban_reason_required': 'Vui lòng nhập lý do khóa.',
    'ban_button_label': 'Khóa',
    'unban_account_title': 'Mở khóa tài khoản',
    'unban_account_confirm': 'Bạn chắc chắn muốn mở khóa "{name}"?',
    'no_users_found': 'Không có người dùng nào.',
    'role_user_label': 'Người dùng',
    'role_content_manager_label': 'Quản lý nội dung',
    'role_admin_label': 'Quản trị',

    // Activity Log UI
    'activity_log': 'Nhật ký hoạt động',
    'activity_log_count': 'bản ghi',
    'activity_log_search_hint': 'Tìm theo email hoặc tên admin...',
    'activity_log_action': 'Hành động',
    'all_actions': 'Tất cả hành động',
    'activity_log_actor': 'Thực hiện bởi',
    'activity_log_resource': 'Loại tài nguyên',
    'activity_log_resource_name': 'Tên tài nguyên',
    'activity_log_from': 'Từ ngày',
    'activity_log_to': 'Đến ngày',

    // Statistics UI
    'statistics': 'Thống kê',
    'stats_subtitle': 'Phân tích dữ liệu nghe nhạc và hoạt động người dùng.',
    'stats_plays_daily': 'Lượt phát theo ngày',
    'stats_top_songs': 'Top bài hát',
    'stats_top_artists': 'Top nghệ sĩ',
    'stats_dau': 'DAU',
    'stats_dau_subtitle': 'Người dùng hoạt động ngày {date}',
    'stats_mau': 'MAU',
    'stats_mau_subtitle': 'Người dùng hoạt động trong {days} ngày gần nhất',

    // ── Response codes ───────────────────────────────────────────────────────
    'success.ok': 'Thành công',

    // Auth / Permission
    'error.unauthorized': 'Phiên đăng nhập đã hết hạn',
    'error.unauthorized.invalid_credentials': 'Email hoặc mật khẩu không đúng',
    'error.unauthorized.invalid_token': 'Token không hợp lệ',
    'error.account_locked': 'Tài khoản đã bị khoá',
    'error.auth.current_password_invalid': 'Mật khẩu hiện tại không chính xác',
    'error.forbidden': 'Bạn không có quyền thực hiện thao tác này',
    'error.forbidden.playlist_access': 'Bạn không có quyền truy cập playlist này',

    // Not found
    'error.not_found': 'Không tìm thấy tài nguyên',
    'error.not_found.user': 'Không tìm thấy người dùng',
    'error.not_found.song': 'Không tìm thấy bài hát',
    'error.not_found.artist': 'Không tìm thấy nghệ sĩ',
    'error.not_found.album': 'Không tìm thấy album',
    'error.not_found.genre': 'Không tìm thấy thể loại',
    'error.not_found.play_history': 'Không tìm thấy lịch sử phát',
    'error.not_found.playlist': 'Không tìm thấy playlist',
    'error.not_found.playlist_song': 'Không tìm thấy bài hát trong playlist',
    'error.not_found.system_playlist': 'Không tìm thấy playlist hệ thống',
    'error.not_found.system_playlist_song':
        'Không tìm thấy bài hát trong playlist hệ thống',
    'error.not_found.favorite': 'Không tìm thấy mục yêu thích',
    'error.not_found.lyrics': 'Không tìm thấy lời bài hát',
    'error.not_found.tag': 'Không tìm thấy tag',

    // Conflict
    'error.conflict': 'Dữ liệu đã tồn tại',
    'error.conflict.email_exists': 'Email đã được sử dụng',
    'error.conflict.favorite_exists': 'Mục yêu thích đã tồn tại',
    'error.conflict.playlist_song_exists': 'Bài hát đã có trong playlist',
    'error.conflict.system_playlist_song_exists':
        'Bài hát đã có trong playlist hệ thống',
    'error.conflict.lyrics_exists': 'Lời bài hát đã tồn tại',
    'error.conflict.slug_exists': 'Slug đã được sử dụng',

    // Bad request / Business rule
    'error.bad_request': 'Yêu cầu không hợp lệ',
    'error.bad_request.invalid_body': 'Dữ liệu gửi lên không đọc được',
    'error.bad_request.type_mismatch': 'Kiểu dữ liệu không đúng',
    'error.query.required': 'Thiếu tham số tìm kiếm',
    'error.song.audio_required': 'Bài hát cần có file audio',
    'error.song.audio_source_not_found': 'Không tìm thấy nguồn audio',
    'error.tag.ids_required': 'Danh sách ID tag không được rỗng',
    'error.playlist.visibility_invalid': 'Chế độ hiển thị playlist không hợp lệ',
    'error.playlist.name_required': 'Tên playlist không được bỏ trống',
    'error.playlist.name_too_long': 'Tên playlist quá dài',
    'error.tag.name_exists': 'Tên tag đã tồn tại',
    'error.tag.name_required': 'Tên tag không được bỏ trống',
    'error.tag.type_required': 'Loại tag không được bỏ trống',
    'error.tag.type_invalid': 'Loại tag không hợp lệ',
    'error.playlist.reorder.invalid': 'Thứ tự playlist không hợp lệ',
    'error.system_playlist.reorder.invalid':
        'Thứ tự playlist hệ thống không hợp lệ',
    'error.lyrics.synced.invalid': 'Định dạng lời bài hát đồng bộ không hợp lệ',

    // System / Storage
    'error.storage.operation_failed': 'Thao tác lưu trữ thất bại',
    'error.internal': 'Lỗi hệ thống nội bộ',

    // Validation
    'validation.not_blank': 'Không được để trống',
    'validation.not_null': 'Giá trị không được null',
    'validation.not_empty': 'Không được rỗng',
    'validation.size.min': 'Giá trị quá nhỏ',
    'validation.size.max': 'Giá trị quá lớn',
    'validation.size.range': 'Giá trị nằm ngoài khoảng cho phép',
    'validation.email': 'Email không hợp lệ',
    'validation.pattern': 'Định dạng không hợp lệ',
    'validation.positive_or_zero': 'Giá trị phải lớn hơn hoặc bằng 0',
    'validation.invalid_format': 'Định dạng không hợp lệ',
    'validation.type_mismatch': 'Kiểu dữ liệu không khớp',
    'validation.required': 'Trường này là bắt buộc',
  };

  static const Map<String, String> _en = {
    // ── UI ──────────────────────────────────────────────────────────────────
    'app_name': 'Ondas Admin',
    'language': 'Language',

    // Auth
    'login_title': 'Sign In',
    'login_subtitle': 'Welcome back! Please sign in to continue.',
    'email_label': 'Email',
    'password_label': 'Password',
    'login_button': 'Sign In',
    'logout_button': 'Sign Out',
    'logging_in': 'Signing in...',

    // Nav / Dashboard
    'dashboard': 'Dashboard',
    'songs': 'Songs',
    'artists': 'Artists',
    'albums': 'Albums',
    'genres': 'Genres',
    'tags': 'Tags / Moods',
    'playlists': 'System Playlists',
    'users': 'Users',

    // Common actions
    'add': 'Add',
    'edit': 'Edit',
    'delete': 'Delete',
    'save': 'Save',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'search': 'Search',
    'filter': 'Filter',
    'reset': 'Reset',
    'close': 'Close',
    'back': 'Back',
    'next': 'Next',
    'previous': 'Previous',
    'loading': 'Loading...',
    'retry': 'Retry',
    'no_data': 'No data available',
    'unknown_error': 'An unknown error occurred',

    // Confirm dialogs
    'delete_confirm_title': 'Confirm Delete',
    'delete_confirm_content': 'Are you sure you want to delete this item?',

    // Table / Pagination
    'rows_per_page': 'Rows per page',
    'total_items': 'Total items',

    // Albums
    'album_info': 'Album Information',
    'cover_image': 'Cover Image',
    'add_album': 'Add Album',
    'edit_album': 'Edit Album',
    'search_album': 'Search albums...',
    'no_albums': 'No albums found.',
    'select_artist': 'Select Artist',
    'select_song': 'Select Songs',
    'release_date': 'Release Date',
    'pick_date': 'Pick a date...',
    'tracklist': 'Songs (Tracklist)',
    'album_type': 'Album Type',
    'album_title': 'Title *',
    'album_description': 'Description',
    'song_in_other_album': 'Already in another album',
    'song_already_in_album': 'In album',
    'page_of': 'Page',
    'upload_image': 'Upload Image',
    'image_hint': 'PNG, JPG or WEBP. Max 5 MB.',
    'title_required': 'Must not be empty',
    'at_least_one_artist': 'Please select at least 1 artist.',
    'at_least_one_genre': 'Please select at least 1 genre.',
    'audio_file_required': 'Please select an audio file when creating a new song.',
    'update_btn': 'Update',
    'create_btn': 'Create',
    'no_artist_yet': 'No artist assigned',

    // Artists
    'artist_count': 'artists',
    'add_artist': 'Add Artist',
    'edit_artist': 'Edit Artist',
    'create_artist': 'Add New Artist',
    'search_artist': 'Search artists...',
    'delete_artist_confirm': 'Are you sure you want to delete artist "{name}"? This action cannot be undone.',
    'no_artists': 'No artists found.',
    'artist_name': 'Artist Name',
    'country': 'Country',
    'slug': 'Slug',
    'actions': 'Actions',
    'basic_info': 'Basic Information',
    'artist_name_hint': 'e.g. Son Tung M-TP',
    'country_hint': 'e.g. Vietnam',
    'slug_hint': 'son-tung-m-tp',
    'bio': 'Biography',
    'bio_hint': 'Description about the artist...',
    'avatar': 'Avatar',
    'avatar_hint': 'PNG, JPG or WEBP. Max 2 MB.',

    // Genres
    'genre_count': 'genres',
    'add_genre': 'Add Genre',
    'edit_genre': 'Edit Genre',
    'create_genre': 'Add New Genre',
    'search_genre': 'Search genres...',
    'delete_genre_confirm': 'Are you sure you want to delete genre "{name}"?',
    'no_genres': 'No genres found.',
    'genre_name': 'Genre Name',
    'genre_name_label': 'Genre Name *',
    'genre_name_hint': 'e.g. V-Pop',
    'genre_slug_hint': 'v-pop',
    'cover_url': 'Cover URL',
    'cover_url_hint': 'https://...',
    'description_hint': 'Short description about this genre...',
    'no_slug': 'No slug',
    'no_description': 'No description',
    'genre_info': 'Genre Information',
    'upload_cover': 'Upload Cover',

    // Lyrics
    'lyrics': 'Lyrics',
    'lyrics_subtitle': 'Update lyrics (plain text or synced).',
    'language_label': 'Language',
    'language_hint': 'e.g. vi, en',
    'synced_lyrics_title': 'Synced Lyrics',
    'synced_lyrics_subtitle_active': 'Enter lyrics with timestamps for each line',
    'synced_lyrics_subtitle_inactive': 'Enter plain text lyrics',
    'delete_lyrics': 'Delete Lyrics',
    'update_lyrics': 'Update Lyrics',
    'create_lyrics': 'Create Lyrics',
    'plain_lyrics_label': 'Lyrics',
    'plain_lyrics_hint': 'Enter plain text lyrics...',
    'synced_lines_title': 'Synced Lines',
    'add_line': 'Add Line',
    'no_synced_lines': 'No lines added yet. Click "Add Line" to start.',
    'insert_line_after': 'Insert line after',
    'delete_line': 'Delete this line',
    'line_text_label': 'Line {num} text',
    'line_text_hint': 'Enter text...',
    'delete_lyrics_confirm_title': 'Confirm Delete',
    'delete_lyrics_confirm_content': 'Are you sure you want to delete lyrics for this song?',
    'validation_synced_line_required': 'Each synced line must have content.',
    'validation_start_format_error': 'Line {num}: Start must be formatted as mm:ss (e.g. 01:18.5).',
    'validation_end_format_error': 'Line {num}: End must be formatted as mm:ss (e.g. 01:18.5).',

    // Playlists
    'delete_playlist_confirm': 'Are you sure you want to delete playlist "{name}"?',
    'playlist_count': 'system playlists',
    'add_playlist': 'Add System Playlist',
    'edit_playlist': 'Edit System Playlist',
    'search_playlist': 'Search system playlists...',
    'playlist_info': 'Playlist Information',
    'playlist_name_label': 'Playlist Name *',
    'playlist_name_hint': 'e.g. Top hits',
    'active_status': 'Active',
    'hidden_status': 'Hidden',
    'playlist_active_desc': 'Playlist is visible to users.',
    'playlist_hidden_desc': 'Playlist is hidden from users.',
    'playlist_desc_hint': 'Playlist description...',
    'song_list': 'Song List',
    'add_song': 'Add Song',
    'reorder_songs_desc': 'Drag & drop to reorder. {count} songs.',
    'empty_playlist': 'No songs in playlist.',
    'remove_from_playlist': 'Remove from playlist',
    'add_song_to_playlist': 'Add Song to Playlist',
    'search_song': 'Search songs...',
    'no_matching_songs': 'No matching songs.',
    'no_playlists': 'No playlists found',
    'playlist': 'Playlist',
    'updated': 'Updated',
    'songs_count': 'songs',

    // Songs UI
    'add_song_new': 'Add New Song',
    'edit_song': 'Edit Song',
    'no_songs_yet': 'No songs found',
    'click_add_song_start': 'Click "Add Song" to start',
    'song_library_count': '{count} songs in library',
    'search_song_hint': 'Search songs...',
    'delete_song_confirm': 'Are you sure you want to delete song "{name}"?',
    'song_info': 'Song Information',
    'song_title_label': 'Title *',
    'song_title_hint': 'e.g. Noi nay co anh',
    'no_album_assigned': 'No album assigned',
    'track_number_label': 'Track number',
    'must_be_integer': 'Must be an integer',
    'select_genre_hint': 'Select genre',
    'select_tag_hint': 'Select tags (optional)',
    'only_edit_active': '(Only editable when editing)',
    'media': 'Media',
    'upload_cover_image': 'Upload cover image',
    'replace_audio_file': 'Replace audio file',
    'upload_audio_file': 'Upload audio file *',
    'required_on_create': 'Required when creating new',
    'api_data_source_hint': 'Artist, genre, album, tag data are loaded from API.',
    'lyrics_saved_success': 'Lyrics saved.',
    'lyrics_deleted_success': 'Lyrics deleted.',
    'lyrics_error_prefix': 'Lyrics error: {msg}',
    'song_created_lyrics_failed': '{msg}. But failed to create lyrics: {lyricsMsg}',
    'load_albums_error': 'Could not load albums list',
    'untitled_album': 'Untitled album',
    'inactive_status': 'Inactive',
    'song_column_header': 'SONG',
    'artist_column_header': 'ARTIST',
    'genre_column_header': 'GENRE',
    'duration_column_header': 'DURATION',
    'status_column_header': 'STATUS',
    'actions_column_header': 'ACTIONS',

    // Tags UI
    'add_tag': 'Add Tag',
    'edit_tag': 'Edit Tag',
    'delete_tag_confirm': 'Are you sure you want to delete tag "{name}"?',
    'tags_count': 'tags',
    'search_tag': 'Search tags...',
    'all': 'All',
    'mood': 'Mood',
    'theme': 'Theme',
    'activity': 'Activity',
    'era': 'Era',
    'tag_info': 'Tag Information',
    'tag_name': 'Tag Name',
    'tag_name_hint': 'e.g. Happy',
    'color_hex_label': 'Hex Color',
    'color_hex_hint': 'e.g. #FF9900',
    'invalid_hex_color': 'Invalid format (#RRGGBB)',
    'no_tags_yet': 'No tags found',
    'tag_type_label': 'Type',
    'tag_color_label': 'Color',

    // Users UI
    'accounts_count': 'accounts',
    'search_user_hint': 'Search by email or display name...',
    'all_roles': 'All Roles',
    'all_statuses': 'All Statuses',
    'banned_status': 'Banned',
    'role_label': 'Role',
    'status_label': 'Status',
    'user_detail_title': 'User Details',
    'user_detail_label': 'Details',
    'load_user_detail_error': 'Could not load user details.',
    'display_name_label': 'Display Name',
    'ban_reason_label': 'Ban Reason',
    'banned_at_label': 'Banned At',
    'last_login_label': 'Last Login',
    'created_at_label': 'Created At',
    'ban_account_label': 'Ban Account',
    'unban_account_label': 'Unban',
    'ban_reason_hint': 'Enter ban reason...',
    'ban_reason_required': 'Please enter a ban reason.',
    'ban_button_label': 'Ban',
    'unban_account_title': 'Unban Account',
    'unban_account_confirm': 'Are you sure you want to unban "{name}"?',
    'no_users_found': 'No users found.',
    'role_user_label': 'User',
    'role_content_manager_label': 'Content Manager',
    'role_admin_label': 'Admin',

    // Activity Log UI
    'activity_log': 'Activity Log',
    'activity_log_count': 'records',
    'activity_log_search_hint': 'Search by email or admin name...',
    'activity_log_action': 'Action',
    'all_actions': 'All Actions',
    'activity_log_actor': 'Performed By',
    'activity_log_resource': 'Resource Type',
    'activity_log_resource_name': 'Resource Name',
    'activity_log_from': 'From',
    'activity_log_to': 'To',

    // Statistics UI
    'statistics': 'Statistics',
    'stats_subtitle': 'Analyze music play data and user activity.',
    'stats_plays_daily': 'Daily Play Count',
    'stats_top_songs': 'Top Songs',
    'stats_top_artists': 'Top Artists',
    'stats_dau': 'DAU',
    'stats_dau_subtitle': 'Active users on {date}',
    'stats_mau': 'MAU',
    'stats_mau_subtitle': 'Active users in last {days} days',

    // ── Response codes ───────────────────────────────────────────────────────
    'success.ok': 'Success',

    // Auth / Permission
    'error.unauthorized': 'Session expired, please sign in again',
    'error.unauthorized.invalid_credentials': 'Invalid email or password',
    'error.unauthorized.invalid_token': 'Invalid token',
    'error.account_locked': 'Account has been locked',
    'error.auth.current_password_invalid': 'Current password is incorrect',
    'error.forbidden': 'You do not have permission to perform this action',
    'error.forbidden.playlist_access':
        'You do not have access to this playlist',

    // Not found
    'error.not_found': 'Resource not found',
    'error.not_found.user': 'User not found',
    'error.not_found.song': 'Song not found',
    'error.not_found.artist': 'Artist not found',
    'error.not_found.album': 'Album not found',
    'error.not_found.genre': 'Genre not found',
    'error.not_found.play_history': 'Play history not found',
    'error.not_found.playlist': 'Playlist not found',
    'error.not_found.playlist_song': 'Song not found in playlist',
    'error.not_found.system_playlist': 'System playlist not found',
    'error.not_found.system_playlist_song':
        'Song not found in system playlist',
    'error.not_found.favorite': 'Favorite not found',
    'error.not_found.lyrics': 'Lyrics not found',
    'error.not_found.tag': 'Tag not found',

    // Conflict
    'error.conflict': 'Data already exists',
    'error.conflict.email_exists': 'Email is already in use',
    'error.conflict.favorite_exists': 'Already in favorites',
    'error.conflict.playlist_song_exists': 'Song already exists in playlist',
    'error.conflict.system_playlist_song_exists':
        'Song already exists in system playlist',
    'error.conflict.lyrics_exists': 'Lyrics already exist for this song',
    'error.conflict.slug_exists': 'Slug is already in use',

    // Bad request / Business rule
    'error.bad_request': 'Invalid request',
    'error.bad_request.invalid_body': 'Request body could not be read',
    'error.bad_request.type_mismatch': 'Data type mismatch',
    'error.query.required': 'Search query is required',
    'error.song.audio_required': 'Song must have an audio file',
    'error.song.audio_source_not_found': 'Audio source not found',
    'error.tag.ids_required': 'Tag ID list must not be empty',
    'error.playlist.visibility_invalid': 'Invalid playlist visibility setting',
    'error.playlist.name_required': 'Playlist name is required',
    'error.playlist.name_too_long': 'Playlist name is too long',
    'error.tag.name_exists': 'Tag name already exists',
    'error.tag.name_required': 'Tag name is required',
    'error.tag.type_required': 'Tag type is required',
    'error.tag.type_invalid': 'Invalid tag type',
    'error.playlist.reorder.invalid': 'Invalid playlist order',
    'error.system_playlist.reorder.invalid': 'Invalid system playlist order',
    'error.lyrics.synced.invalid': 'Invalid synced lyrics format',

    // System / Storage
    'error.storage.operation_failed': 'Storage operation failed',
    'error.internal': 'Internal server error',

    // Validation
    'validation.not_blank': 'Must not be blank',
    'validation.not_null': 'Must not be null',
    'validation.not_empty': 'Must not be empty',
    'validation.size.min': 'Value is too small',
    'validation.size.max': 'Value is too large',
    'validation.size.range': 'Value is out of the allowed range',
    'validation.email': 'Invalid email address',
    'validation.pattern': 'Invalid format',
    'validation.positive_or_zero': 'Value must be zero or positive',
    'validation.invalid_format': 'Invalid format',
    'validation.type_mismatch': 'Data type mismatch',
    'validation.required': 'This field is required',
  };

  /// Tra cứu chuỗi theo [key] và [locale].
  /// Trả về [key] gốc nếu chưa có bản dịch (dễ phát hiện thiếu key).
  static String t(String key, Locale locale) {
    final map = locale.languageCode == 'vi' ? _vi : _en;
    return map[key] ?? key;
  }
}
