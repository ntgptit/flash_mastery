/// Enum representing different study session statuses.
enum StudySessionStatus {
  /// Session is in progress.
  inProgress,

  /// Session completed successfully.
  success,

  /// Session was cancelled.
  cancel,
}

extension StudySessionStatusExtension on StudySessionStatus {
  /// Convert status to JSON string (for API communication).
  String toJson() {
    switch (this) {
      case StudySessionStatus.inProgress:
        return 'IN_PROGRESS';
      case StudySessionStatus.success:
        return 'SUCCESS';
      case StudySessionStatus.cancel:
        return 'CANCEL';
    }
  }

  /// Display name for the status.
  String get displayName {
    switch (this) {
      case StudySessionStatus.inProgress:
        return 'Đang học';
      case StudySessionStatus.success:
        return 'Hoàn thành';
      case StudySessionStatus.cancel:
        return 'Đã hủy';
    }
  }
}

/// Convert JSON string to StudySessionStatus.
StudySessionStatus studySessionStatusFromJson(String json) {
  switch (json.toUpperCase()) {
    case 'IN_PROGRESS':
      return StudySessionStatus.inProgress;
    case 'SUCCESS':
      return StudySessionStatus.success;
    case 'CANCEL':
    case 'CANCELLED':
      return StudySessionStatus.cancel;
    default:
      return StudySessionStatus.inProgress;
  }
}

