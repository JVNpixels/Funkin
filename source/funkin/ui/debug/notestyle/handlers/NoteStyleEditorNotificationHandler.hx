package funkin.ui.debug.notestyle.handlers;

import haxe.ui.notifications.Notification;
import haxe.ui.notifications.NotificationType;
import haxe.ui.notifications.NotificationManager;

#if FEATURE_NOTESTYLE_EDITOR

/**
 * Handles showing notifications for the NoteStyle Editor.
 * This handler also has shortcut/alias functions.
 */
@:nullSafety @:access(funkin.ui.debug.notestyle.NoteStyleEditorState)
class NoteStyleEditorNotificationHandler
{
  public static function showNotification(state:NoteStyleEditorState, name:String, message:String, notificationType:NotificationType)
  {
    NotificationManager.instance.addNotification(
    {
      title: name,
      body: message,
      type: notificationType ?? NotificationType.Default,
      expiryMs: Constants.NOTIFICATION_DISMISS_TIME,
    });
  }

  /**
   * Send a notification with a checkmark icon indicating a successful action.
   * @param state The current state of the notestyle editor.
   * @param name The title of the notification.
   * @param message The message of the notification.
   */
  public static function success(state:NoteStyleEditorState, name:String, message:String)
  {
    showNotification(state, name, message, NotificationType.Success);
  }

  /**
   * Send a notification with an info icon.
   * @param state The current state of the notestyle editor.
   * @param name The title of the notification.
   * @param message The message of the notification.
   */
  public static function info(state:NoteStyleEditorState, name:String, message:String)
  {
    showNotification(state,name, message, NotificationType.Info);
  }

  /**
   * Send a notification with a warning icon.
   * @param state The current state of the notestyle editor.
   * @param name The title of the notification.
   * @param message The message of the notification.
   */
  public static function warning(state:NoteStyleEditorState, name:String, message:String)
  {
    showNotification(state, name, message, NotificationType.Warning);
  }

  /**
   * Send a notification with a warning icon indicating an error or failure.
   * @param state The current state of the notestyle editor.
   * @param name The title of the notification.
   * @param message The message of the notification.
   */
  public static function error(state:NoteStyleEditorState, name:String, message:String)
  {
    showNotification(state, name, message, NotificationType.Error);
  }

  /**
   * Clear all active notifications.
   * @param state The current state of the notestyle editor.
   */
  public static function clearNotifications(state:NoteStyleEditorState):Void
  {
    NotificationManager.instance.clearNotifications();
  }

  /**
   * Clear a specific notification.
   * @param state The current state of the notestyle editor.
   * @param notif The notification to clear.
   */
  public static function clearNotification(state:NoteStyleEditorState, notif:Notification):Void
  {
    NotificationManager.instance.removeNotification(notif);
  }
}
#end