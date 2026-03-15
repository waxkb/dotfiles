import QtQuick

QtObject {
    readonly property color surface: "{{colors.surface.default.hex}}"
    readonly property color surfaceContainerLow: "{{colors.surface.default.hex}}"
    readonly property color surfaceContainer: "{{colors.surface.default.hex}}"
    readonly property color surfaceContainerHigh: "{{colors.surface.default.hex}}"
    readonly property color surfaceOverlay: "{{colors.scrim.default.hex}}"

    readonly property color primary: "{{colors.primary.default.hex}}"
    readonly property color fgPrimary: "{{colors.on_primary.default.hex}}"
    readonly property color primaryContainer: "{{colors.primary_container.default.hex}}"
    readonly property color fgPrimaryContainer: "{{colors.on_primary_container.default.hex}}"

    readonly property color secondary: "{{colors.secondary.default.hex}}"
    readonly property color fgSecondary: "{{colors.on_secondary.default.hex}}"
    readonly property color secondaryContainer: "{{colors.secondary_container.default.hex}}"
    readonly property color fgSecondaryContainer: "{{colors.on_secondary_container.default.hex}}"

    readonly property color tertiary: "{{colors.tertiary.default.hex}}"
    readonly property color fgTertiary: "{{colors.on_tertiary.default.hex}}"
    readonly property color tertiaryContainer: "{{colors.tertiary_container.default.hex}}"
    readonly property color fgTertiaryContainer: "{{colors.on_tertiary_container.default.hex}}"

    readonly property color error: "{{colors.error.default.hex}}"
    readonly property color fgError: "{{colors.on_error.default.hex}}"
    readonly property color errorContainer: "{{colors.error_container.default.hex}}"
    readonly property color fgErrorContainer: "{{colors.on_error_container.default.hex}}"

    readonly property color background: "{{colors.background.default.hex}}"
    readonly property color fgBackground: "{{colors.on_background.default.hex}}"

    readonly property color outline: "{{colors.outline.default.hex}}"
    readonly property color outlineVariant: "{{colors.outline_variant.default.hex}}"

    readonly property color fgSurface: "{{colors.on_surface.default.hex}}"
    readonly property color fgSurfaceVariant: "{{colors.on_surface_variant.default.hex}}"

    readonly property color inverseSurface: "{{colors.surface.default.hex}}"
    readonly property color fgInverseSurface: "{{colors.on_surface.default.hex}}"
    readonly property color inversePrimary: "{{colors.inverse_primary.default.hex}}"

    readonly property color scrim: "{{colors.scrim.default.hex}}"

    readonly property color accentGreen: "{{colors.tertiary.default.hex}}"
}
