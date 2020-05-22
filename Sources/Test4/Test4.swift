import Foundation

protocol Validator {
    associatedtype ValidatorError: Equatable
    static func validate(text: String) -> ValidationResult<ValidatorError>
}

public enum ValidationResult<E: Equatable>: Equatable {

    case valid
    case invalid([E])
}

class RegexTextValidator {

    let predicate: NSPredicate

    init(regex: String) {
        self.predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    }

    func isValid(_ text: String) -> Bool {
        return predicate.evaluate(with: text)
    }
}

extension RegexTextValidator {

    static var email: RegexTextValidator {
        RegexTextValidator(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,32}")
    }

    static var login: RegexTextValidator {
        RegexTextValidator(regex: "[A-Z0-9a-z.-]{0,}")
    }

    static var firstCharacterlogin: RegexTextValidator {
        RegexTextValidator(regex: "[A-Za-z]{1}")
    }
}

public enum LoginValidator: Validator {

    typealias Result = ValidationResult<ValidatorError>

    enum ValidatorError: Equatable {
        case emailError
        case maxLengthError
        case minLengthError
        case compositionError
        case startCharacterError

        var message: String {
            switch self {
            case .emailError:
                return "Логин представлен невалидным e-mail'ом."
            case .maxLengthError:
                return "Максимальная длина логина - 32 символа."
            case .minLengthError:
                return "Минимальная длина логина - 3 символа."
            case .compositionError:
                return "Логин может состоять из латинских букв, цифр, минуса и точки."
            case .startCharacterError:
                return "Логин не может начинаться на цифру, точку, минус."
            }
        }
    }

    static func validate(text: String) -> ValidationResult<ValidatorError> {

        var validationErrors: [ValidatorError] = []

        if text.contains("@") {
            if RegexTextValidator.email.isValid(text) {
                return .valid
            }

            return .invalid([.emailError])
        }

        if text.count < 3 {
            validationErrors.append(.minLengthError)
        }

        if text.count > 32 {
            validationErrors.append(.maxLengthError)
        }

        if let fChar = text.first, !RegexTextValidator.firstCharacterlogin.isValid(String(fChar)) {
            validationErrors.append(.startCharacterError)
        }

        if !RegexTextValidator.login.isValid(text) {
            validationErrors.append(.compositionError)
        }

        if validationErrors.isEmpty {
            return .valid
        }

        return .invalid(validationErrors)
    }
}
