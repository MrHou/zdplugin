package com.hgy.flutter.zd.flutter_zendes_plugin

import android.app.Activity
import android.text.TextUtils
import androidx.annotation.NonNull
import com.zendesk.logger.Logger
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import zendesk.chat.*
import zendesk.configurations.Configuration
import zendesk.core.AnonymousIdentity
import zendesk.core.Identity
import zendesk.core.JwtIdentity
import zendesk.core.Zendesk
import zendesk.messaging.MessagingActivity
import zendesk.support.Support
import zendesk.support.guide.HelpCenterActivity
import zendesk.support.request.RequestActivity
import zendesk.support.requestlist.RequestListActivity


public class FlutterZendesPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel =
            MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, "flutter_zendes_plugin")
        channel.setMethodCallHandler(this);
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_zendes_plugin")
            channel.setMethodCallHandler(FlutterZendesPlugin())
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "init" -> {
                Logger.setLoggable(BuildConfig.DEBUG)
                val accountKey = call.argument<String>("accountKey") ?: ""
                val applicationId = call.argument<String>("applicationId") ?: ""
                val clientId = call.argument<String>("clientId") ?: ""
                val domainUrl = call.argument<String>("domainUrl") ?: ""
                val jwtToken = call.argument<String>("jwtToken") ?: ""
                if (TextUtils.isEmpty(domainUrl) || TextUtils.isEmpty(accountKey) || TextUtils.isEmpty(
                        clientId
                    ) || TextUtils.isEmpty(applicationId) || TextUtils.isEmpty(jwtToken)
                ) {
                    result.success(false)
//                    result.error("ACCOUNT_KEY_NULL", "AccountKey is null !", "AccountKey is null !")
                    return;
                }

                //1.Zendes SDK
                Zendesk.INSTANCE.init(
                    activity,
                    domainUrl,
                    applicationId,
                    clientId
                )
                //2.Support SDK init
                Support.INSTANCE.init(Zendesk.INSTANCE)

                //3.setIdentity
                val identity: Identity = JwtIdentity(jwtToken)
                Zendesk.INSTANCE.setIdentity(identity)

                //4.Chat SDK
                Chat.INSTANCE.init(activity, accountKey)
                result.success(true)
            }
            "startChatV2" -> {
                val phone = call.argument<String>("phone") ?: ""
                val email = call.argument<String>("email") ?: ""
                val name = call.argument<String>("name") ?: ""
                val botLabel = call.argument<String>("botLabel") ?: "Jasper"
                val toolbarTitle = call.argument<String>("toolbarTitle")
                val endChatSwitch = call.argument<Boolean>("endChatSwitch") ?: true
                val departmentName = call.argument<String>("departmentName") ?: ""
                //MARK: now we don't have bot image from, only from platform
                val botAvatar = call.argument<Int>("botAvatar") ?: R.drawable.zui_avatar_bot_default
                val profileProvider = Chat.INSTANCE.providers()?.profileProvider()
                val chatProvider = Chat.INSTANCE.providers()?.chatProvider()

                val visitorInfo =
                    VisitorInfo
                        .builder()
                        .withName(name)
                        .withEmail(email)
                        .withPhoneNumber(phone)
                        .build()

                profileProvider?.setVisitorInfo(visitorInfo, null)
                profileProvider?.setVisitorNote("Name : $name , Phone: $phone")
//                chatProvider?.setDepartment(departmentName, null)

//                Chat.INSTANCE.providers()?.connectionProvider()?.observeConnectionStatus(ObservationScope(), object : Observer<ConnectionStatus> {
//                   override  fun update(connectionStatus: ConnectionStatus) {
//                        if (connectionStatus == ConnectionStatus.CONNECTED) {
//                            profileProvider?.setVisitorInfo(visitorInfo, null)
//                        }
//                    }
//                })
                val chatConfigurationBuilder = ChatConfiguration.builder();
                chatConfigurationBuilder
                    //If true, and no agents are available to serve the visitor, they will be presented with a message letting them know that no agents are available. If it's disabled, visitors will remain in a queue waiting for an agent. Defaults to true.
                    .withAgentAvailabilityEnabled(true)
                    //If true, visitors will be prompted at the end of the chat if they wish to receive a chat transcript or not. Defaults to true.
                    .withTranscriptEnabled(true)
                    .withOfflineFormEnabled(true)
                    //If true, visitors are prompted for information in a conversational manner prior to starting the chat. Defaults to true.
                    .withPreChatFormEnabled(false)
                    .withNameFieldStatus(PreChatFormFieldStatus.OPTIONAL)
                    .withEmailFieldStatus(PreChatFormFieldStatus.OPTIONAL)
                    .withPhoneFieldStatus(PreChatFormFieldStatus.OPTIONAL)
                    .withDepartmentFieldStatus(PreChatFormFieldStatus.OPTIONAL)
                if (!endChatSwitch) {
                    chatConfigurationBuilder.withChatMenuActions(ChatMenuAction.CHAT_TRANSCRIPT)
                }
                val chatConfiguration = chatConfigurationBuilder.build();

                MessagingActivity.builder()
                    .withBotLabelString(botLabel)
                    .withBotAvatarDrawable(botAvatar)
                    .withToolbarTitle(toolbarTitle)
                    .withEngines(ChatEngine.engine())
                    .show(activity, chatConfiguration)

            }
            "helpCenter" -> {
                val categoriesCollapsed = call.argument<Boolean>("categoriesCollapsed") ?: false
                val contactUsButtonVisible = call.argument<Boolean>("contactUsButtonVisible")
                    ?: true
                val showConversationsMenuButton =
                    call.argument<Boolean>("showConversationsMenuButton")
                        ?: true
                val helpCenterConfig: Configuration = HelpCenterActivity.builder()
                    .withCategoriesCollapsed(categoriesCollapsed)
                    .withContactUsButtonVisible(contactUsButtonVisible)
                    .withShowConversationsMenuButton(showConversationsMenuButton)
                    .config()
                HelpCenterActivity.builder()
                    .show(activity, helpCenterConfig)
            }
            "requestView" -> {
                RequestActivity.builder()
                    .show(activity);
            }
            "requestListView" -> {
                RequestListActivity.builder()
                    .show(activity);
            }
            "changeNavStatus" -> {

            }
            else -> {
                result.notImplemented()
            }
        }
    }
}
