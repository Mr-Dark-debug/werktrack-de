class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.isStudent,
    required this.tracksResidenceAllowance,
  });
  final String displayName;
  final bool isStudent;
  final bool tracksResidenceAllowance;
}
