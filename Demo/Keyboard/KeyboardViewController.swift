//
//  KeyboardViewController.swift
//  Keyboard
//
//  Created by Daniel Saidi on 2021-02-11.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import KeyboardKit
import SwiftUI

/**
 This keyboard demonstrates how to create a keyboard that is
 using a `SystemKeyboard` to mimic a native English keyboard.

 This keyboard also uses a couple of custom services to show
 you how you can change locale, style, autocomplete, etc.

 To use this keyboard, you must enable it in system settings
 ("Settings/General/Keyboards"). It needs full access to get
 access to features like haptic feedback.
 */
class KeyboardViewController: KeyboardInputViewController {

    /**
     This function is called when the controller loads. Here,
     we make demo-specific service configurations.
     */
    override func viewDidLoad() {

        /// 💡 Setup a custom keyboard locale.
        ///
        /// Without KeyboardKit Pro, changing locale will by
        /// default only affects localized texts.
        keyboardContext.setLocale(.english)

        /// 💡 Add more locales to the keyboard.
        ///
        /// The demo layout provider will add a "next locale"
        /// menu button if you have more than one locale.
        keyboardContext.localePresentationLocale = .current
        // keyboardContext.locales = KeyboardLocale.allCases.map { $0.locale }
        
        /// 💡 Setup a demo-specific action handler.
        ///
        /// The demo handler has custom code for tapping and
        /// long pressing image actions.
        keyboardActionHandler = DemoActionHandler(
            controller: self)
        
        /// 💡 Setup a demo-specific layout provider.
        ///
        /// The demo provider adds a "next locale" button if
        /// needed, as well as a rocket emoji button.
        keyboardServices.layoutProvider = DemoLayoutProvider()
        
        /// 💡 Setup a fake autocomplete provider.
        ///
        /// This fake provider will provide fake suggestions.
        /// Try the Pro demo for real suggestions.
        keyboardServices.autocompleteProvider = FakeAutocompleteProvider()
        
        /// 💡 Setup a demo-specific callout action provider.
        ///
        /// The demo provider adds "keyboard" callout action
        /// buttons to the "k" key.
        keyboardServices.calloutActionProvider = StandardCalloutActionProvider(
            keyboardContext: keyboardContext,
            baseProvider: DemoCalloutActionProvider())
        
        /// 💡 Setup a demo-specific style provider.
        ///
        /// The demo provider has some commented out changes
        /// that you can enable to see the effect.
        keyboardServices.styleProvider = DemoStyleProvider(
            keyboardContext: keyboardContext)
        
        /// 💡 Change the space long press behavior.
        ///
        /// The locale context menu will only open up if the
        /// keyboard has multiple locales.
        // keyboardContext.spaceLongPressBehavior = .openLocaleContextMenu

        /// 💡 Setup a custom dictation key replacement.
        ///
        /// Since dictation is not available by default, the
        /// dictation button is removed if we don't set this.
        keyboardContext.keyboardDictationReplacement = .keyboardType(.emojis)
        
        /// 💡 Enable haptic feedback.
        ///
        /// The default haptic feedback is `.minimal`, which
        /// only has haptic feedback for long press on space.
        feedbackConfiguration.enableHapticFeedback()
        // keyboardFeedbackSettings.audioConfiguration.input = .custom(id: 1329)
        
        /// 💡 Call super to perform the base initialization.
        super.viewDidLoad()
    }

    /**
     This function is called whenever the keyboard should be
     created or updated. Here, we setup a system keyboard.
     */
    override func viewWillSetupKeyboard() {
        super.viewWillSetupKeyboard()

        /// 💡 Make the demo use a ``SystemKeyboard``.
        ///
        /// This is not needed if you want to use a standard
        /// system keyboard, but this is how you can replace
        /// or customize the standard view.
        setup { controller in
            SystemKeyboard(
                controller: controller,
                buttonContent: { $0.view },
                buttonView: { $0.view },
                emojiKeyboard: { $0.view },
                toolbar: { $0.view }
            )
        }
    }
}
