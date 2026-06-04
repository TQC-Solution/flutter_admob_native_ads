import UIKit

/// Extension for UIView to simplify Auto Layout constraint creation.
extension UIView {

    /// Pins all edges of the view to its superview with optional insets.
    ///
    /// - Parameter insets: Edge insets to apply (default: .zero)
    /// - Returns: Array of activated constraints
    @discardableResult
    func pinToSuperview(with insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }

        translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ]

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Centers the view in its superview.
    ///
    /// - Returns: Array of activated constraints (centerX and centerY)
    @discardableResult
    func centerInSuperview() -> [NSLayoutConstraint] {
        guard let superview = superview else { return [] }

        translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Sets the width and/or height of the view.
    ///
    /// - Parameters:
    ///   - width: Width to set (optional)
    ///   - height: Height to set (optional)
    /// - Returns: Array of activated constraints
    @discardableResult
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []

        if let width = width {
            constraints.append(widthAnchor.constraint(equalToConstant: width))
        }

        if let height = height {
            constraints.append(heightAnchor.constraint(equalToConstant: height))
        }

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// Pins the top edge to another view's bottom edge.
    ///
    /// - Parameters:
    ///   - view: The view to pin below
    ///   - spacing: Spacing between views
    /// - Returns: The activated constraint
    @discardableResult
    func pinBelow(_ view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: spacing)
        constraint.isActive = true
        return constraint
    }

    /// Pins the leading edge to another view's trailing edge.
    ///
    /// - Parameters:
    ///   - view: The view to pin after
    ///   - spacing: Spacing between views
    /// - Returns: The activated constraint
    @discardableResult
    func pinAfter(_ view: UIView, spacing: CGFloat = 0) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: spacing)
        constraint.isActive = true
        return constraint
    }
}

/// Helper for creating horizontal stack views.
func createHorizontalStack(
    spacing: CGFloat = 8,
    alignment: UIStackView.Alignment = .center,
    distribution: UIStackView.Distribution = .fill
) -> UIStackView {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = spacing
    stack.alignment = alignment
    stack.distribution = distribution
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
}

/// Helper for creating vertical stack views.
func createVerticalStack(
    spacing: CGFloat = 8,
    alignment: UIStackView.Alignment = .fill,
    distribution: UIStackView.Distribution = .fill
) -> UIStackView {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = spacing
    stack.alignment = alignment
    stack.distribution = distribution
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
}
