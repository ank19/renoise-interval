--   _______ __   __ _______        _______       _____  _______      _______ _____ _______ _______ _     _ _______
--   |         \_/   |       |      |______      |     | |______      |______   |   |______    |    |_____| |______
--   |_____     |    |_____  |_____ |______      |_____| |            |       __|__ |          |    |     | ______|
--

-- C  C#  D  D#  E  F  F#  G  G#  A  A#  B
-- 0  1   2  3   4  5  6   7  8   9  10  11

CYCLE_OF_FIFTHS = {               --|--
  -- Centered on C  (C# G# D# A# F  C  G  D  A  E  B  F#)
  { 1, 8, 3, 10, 5, 0, 7, 2, 9, 4, 11, 6 },
  -- Centered on C# (D  A  E  B  F# C# G# D# A# F  C  G )
  { 2, 9, 4, 11, 6, 1, 8, 3, 10, 5, 0, 7 },
  -- Centered on D  (D# A# F  C  G  D  A  E  B  F# C# G#)
  { 3, 10, 5, 0, 7, 2, 9, 4, 11, 6, 1, 8 },
  -- Centered on D# (E  B  F# C# G# D# A# F  C  G  D  A )
  { 4, 11, 6, 1, 8, 3, 10, 5, 0, 7, 2, 9 },
  -- Centered on E  (F  C  G  D  A  E  B  F# C# G# D# A#)
  { 5, 0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10 },
  -- Centered on F  (F# C# G# D# A# F  C  G  D  A  A# B )
  { 6, 1, 8, 3, 10, 5, 0, 7, 2, 9, 4, 11 },
  -- Centered on F# (G  D  A  E  B  F# C# G# D# A# F  C )
  { 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5, 0 },
  -- Centered on G  (G# D# A# F  C  G  D  A  E  B  F# C#)
  { 8, 3, 10, 5, 0, 7, 2, 9, 4, 11, 6, 1 },
  -- Centered on G# (A  E  B  F# C# G# D# A# F  C  G  D )
  { 9, 4, 11, 6, 1, 8, 3, 10, 5, 0, 7, 2 },
  -- Centered on A  (A# F  C  G  D  A  E  B  F# C# G# D#)
  { 10, 5, 0, 7, 2, 9, 4, 11, 6, 1, 8, 3 },
  -- Centered on A# (B  F# C# G# D# A# F  C  G  D  A  A#)
  { 11, 6, 1, 8, 3, 10, 5, 0, 7, 2, 9, 4 },
  -- Centered on B  (C  G  D  A  E  B  F# C# G# D# A# F )
  { 0, 7, 2, 9, 4, 11, 6, 1, 8, 3, 10, 5 }
}

EQUAL_TEMPERAMENT =
-- The same fractions are used as just tuning, as, of course, the irrational numbers of the equal temperament cannot
-- be represented as whole number fractions. Just tuning is used as a approximation. Pls. also note that there is a
-- special rule in the interval_properties() method for calculating cents, as these ratios cannot be used, of course.
  { {  1,   1},
    { 16,  15},
    {  9,   8},
    {  6,   5},
    {  5,   4},
    {  4,   3},
    {  7,   5},
    {  3,   2},
    {  8,   5},
    {  5,   3},
    {  9,   5},
    { 15,   8},
    {  2,   1} }

PURE_INTERVALS =
  -- Pure intervals
  { {  1,   1},
    { 16,  15},
    {  9,   8},
    {  6,   5},
    {  5,   4},
    {  4,   3},
    { 45,  32},
    {  3,   2},
    {  8,   5},
    {  5,   3},
    { 16,   9},
    { 15,   8},
    {  2,   1} }

--   _______  _____          _____   ______ _______
--   |       |     | |      |     | |_____/ |______
--   |_____  |_____| |_____ |_____| |    \_ ______|
--

COLOR_HEADER_1 = {0x3A, 0x3A, 0x3A}
COLOR_HEADER_2 = {0x50, 0x50, 0x50}

COLOR_DISSONANCE_X = {0x00, 0x0F, 0x00}
COLOR_DISSONANCE_1 = {0x20, 0x5F, 0x20}
COLOR_DISSONANCE_2 = {0x20, 0x3F, 0x20}
COLOR_DISSONANCE_3 = {0x3F, 0x20, 0x20}
COLOR_DISSONANCE_4 = {0x5F, 0x20, 0x20}

COLOR_IS_NOTE        = {0x58, 0x58, 0x58}
COLOR_NO_NOTE        = {0xA8, 0xA8, 0xA8}
COLOR_IS_NOTE_MARKER = {0x18, 0x18, 0x20}
COLOR_NO_NOTE_MARKER = {0xA8, 0xA8, 0xA8}

DISSONANCE_COLORS = {COLOR_DISSONANCE_1, COLOR_DISSONANCE_2, COLOR_DISSONANCE_3, COLOR_DISSONANCE_4}

COLOR_DEFAULT = {0x90, 0x90, 0x90}
COLOR_BLACK   = {0x00, 0x00, 0x00}

COLOR_STATUS_WARNING = {0xB0, 0x40, 0x00}

--   _______ _____ ______ _______ _______
--   |______   |    ____/ |______ |______
--   ______| __|__ /_____ |______ ______|
--

HEADER_HEIGHT = 20

--   _____ ______  _______
--     |   |     \ |______
--   __|__ |_____/ ______|
--

ID_HEADER_CHORD_ACTUAL           = "header_chord_actual"
ID_HEADER_CHORD_LINGER           = "header_chord_linger"
ID_SETTINGS                      = "settings"
ID_SETTINGS_INTERVAL             = "settings_interval"
ID_SETTINGS_TUNING               = "settings_tuning"
ID_SETTINGS_DISSONANCE_THRESHOLD = "settings_dissonance_threshold"
ID_SETTINGS_HEARING_THRESHOLD    = "settings_hearing_threshold"
ID_SETTINGS_VOLUME_REDUCTION     = "settings_volume_reduction"
ID_SETTINGS_PITCH                = "settings_pitch"
ID_SETTINGS_TUNING_NOTE          = "settings_tuning_note"
ID_SETTINGS_SEARCH_ROWS          = "settings_search_rows"
ID_SETTINGS_MATRIX_SIZE          = "settings_matrix_size"
ID_SETTINGS_DEBUG                = "settings_debug"
ID_ELEMENT                       = "element"
ID_STATUS_BAR                    = "status_bar"
ID_COUNTERPOINT_BAR              = "counterpoint_bar"
ID_SETTINGS_CHORD_CALC           = "chord_calculation"
ID_SETTINGS_CHORD_CALC_BOX       = "chord_calculation_box"
ID_SETTINGS_REOPEN_NOTE          = "reopen_note"

--   _______ _______ _______ _______ _     _ _______
--   |______    |    |_____|    |    |     | |______
--   ______|    |    |     |    |    |_____| ______|
--

STATUS_OK                      = "ok"
STATUS_LINES_OMITTED           = "omitted"
COUNTERPOINT_PATTERN_VIOLATION = "pattern_violation"
COUNTERPOINT_OK                = "ok"
