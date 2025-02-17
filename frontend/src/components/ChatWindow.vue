<script setup lang="tsx" setup>
import { Bubble } from 'ant-design-x-vue';
import { UserOutlined } from '@ant-design/icons-vue';
import { Flex } from 'ant-design-vue';
import type { CSSProperties } from 'vue';

defineOptions({ name: 'BubbleAvatarAndPlacement' });

const fooAvatar: CSSProperties = {
  color: '#f56a00',
  backgroundColor: '#fde3cf',
};

const barAvatar: CSSProperties = {
  color: '#fff',
  backgroundColor: '#87d068',
};

const hideAvatar: CSSProperties = {
  visibility: 'hidden',
};

defineRender(() => {
  return (
    <Flex gap="middle" vertical>
      <Bubble
        placement="start"
        content="Good morning, how are you?"
        avatar={{ icon: <UserOutlined />, style: fooAvatar }}
      />
      <Bubble
        placement="start"
        content="What a beautiful day!"
        styles={{ avatar: hideAvatar }}
        avatar={{}}
      />
      <Bubble
        placement="end"
        content="Hi, good morning, I'm fine!"
        avatar={{ icon: <UserOutlined />, style: barAvatar }}
      />
      <Bubble placement="end" content="Thank you!" styles={{ avatar: hideAvatar }} avatar={{}} />
    </Flex>
  )
});
</script>