import SwiftUI

struct Student: Identifiable, Hashable {
    let id: UUID
    var name: String
    var mark: Int

    init(id: UUID = UUID(), name: String, mark: Int) {
        self.id = id
        self.name = name
        self.mark = mark
    }

    // Required by core practical requirements
    var passed: Bool {
        mark >= 50
    }

    // Standard letter grading
    var grade: String {
        switch mark {
        case 80...100: return "A"
        case 75..<80:  return "A-"
        case 70..<75:  return "B+"
        case 65..<70:  return "B"
        case 60..<65:  return "B-"
        case 55..<60:  return "C+"
        case 45..<55:  return "C"
        case 40..<45:  return "C-"
        default:       return "F"
        }
    }

    // 4.0 GPA equivalent
    var gpa: Double {
        switch mark {
        case 85...100: return 4.0
        case 80..<85:  return 3.7
        case 75..<80:  return 3.3
        case 70..<75:  return 3.0
        case 65..<70:  return 2.7
        case 60..<65:  return 2.3
        case 55..<60:  return 2.0
        case 50..<55:  return 1.7
        case 45..<50:  return 1.3
        case 40..<45:  return 1.0
        default:       return 0.0
        }
    }

    // Performance tier
    var tierTitle: String {
        switch mark {
        case 80...100: return "Distinction"
        case 70..<80:  return "Merit"
        case 60..<70:  return "Credit"
        case 50..<60:  return "Standard Pass"
        default:       return "Needs Review"
        }
    }

    var tierIcon: String {
        switch mark {
        case 80...100: return "trophy.fill"
        case 70..<80:  return "sparkles"
        case 60..<70:  return "star.fill"
        case 50..<60:  return "checkmark.circle.fill"
        default:       return "arrow.triangle.2.circlepath"
        }
    }

    var accentColor: Color {
        switch mark {
        case 75...100: return AppTheme.brandEmerald
        case 60..<75:  return AppTheme.brandCyan
        case 50..<60:  return AppTheme.brandAmber
        default:       return AppTheme.brandCoral
        }
    }

    var accentGradient: LinearGradient {
        switch mark {
        case 75...100: return AppTheme.emeraldGradient
        case 60..<75:  return AppTheme.primaryGradient
        case 50..<60:  return AppTheme.goldGradient
        default:       return AppTheme.coralGradient
        }
    }

    var initials: String {
        let parts = name.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        if parts.count >= 2, let first = parts.first?.first, let second = parts.last?.first {
            return "\(first)\(second)".uppercased()
        } else if let first = name.first {
            return String(first).uppercased()
        }
        return "S"
    }
}
