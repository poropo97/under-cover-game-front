/// All possible roles in a match.
enum Role {
  civilian,
  undercover,
  mrWhite,
}

/// Extra helpers for UI & game logic.
extension RoleX on Role {
  /// Localised label (placeholder English for now).
  String get label => switch (this) {
        Role.civilian   => 'Civilian',
        Role.undercover => 'Undercover',
        Role.mrWhite    => 'Mr White',
      };

  /// Returns `true` for Undercover or Mr White.
  bool get isSpy => this == Role.undercover || this == Role.mrWhite;
}
