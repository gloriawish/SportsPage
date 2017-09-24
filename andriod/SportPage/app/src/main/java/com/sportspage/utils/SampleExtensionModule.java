package com.sportspage.utils;

import android.widget.EditText;

import java.util.ArrayList;
import java.util.List;

import io.rong.imkit.DefaultExtensionModule;
import io.rong.imkit.RongExtension;
import io.rong.imkit.emoticon.IEmoticonTab;
import io.rong.imkit.plugin.CombineLocationPlugin;
import io.rong.imkit.plugin.IPluginModule;
import io.rong.imkit.plugin.ImagePlugin;
import io.rong.imkit.widget.provider.FilePlugin;
import io.rong.imlib.model.Conversation;

/**
 * Created by Tenma on 2016/11/26.
 */

public class SampleExtensionModule extends DefaultExtensionModule {

    @Override
    public List<IPluginModule> getPluginModules(Conversation.ConversationType conversationType) {
//        super.getPluginModules(conversationType);  如果需要对红包进行排序可从父类中的 getPluginModules 集合中过滤取出 JrmfExtensionModule
        List<IPluginModule> pluginModuleList = new ArrayList<>();

        pluginModuleList.add(new ImagePlugin());
//        pluginModuleList.add(new ());
        pluginModuleList.add(new CombineLocationPlugin());



        return pluginModuleList;
    }


    @Override
    public void onAttachedToExtension(RongExtension extension) {
       super.onAttachedToExtension(extension);
    }

    @Override
    public void onDetachedFromExtension() {
        super.onDetachedFromExtension();
    }

    @Override
    public List<IEmoticonTab> getEmoticonTabs() {
        return super.getEmoticonTabs();
    }

}
