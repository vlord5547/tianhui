import React, { useState } from 'react';
import { View, Text } from 'react-native';
import { Input, Button, Card, Toggle, Select } from 'shadcn-ui';
import axios from 'axios';
import { useNavigation } from '@react-navigation/native';

export default function SettingsScreen() {
  const navigation = useNavigation();
  const [keyword, setKeyword] = useState('');
  const [city, setCity] = useState('上海');
  const [listenReturn, setListenReturn] = useState(false);
  const [interval, setInterval] = useState('5');

  const startListening = async () => {
    try {
      await axios.post('/api/startListening', {
        keyword,
        city,
        listenReturn,
        interval: Number(interval)
      });
      navigation.navigate('Status');
    } catch (e) {
      console.error(e);
    }
  };

  return (
    <View className="flex-1 bg-gray-100 p-4">
      <Text className="text-xl font-bold mb-4">Settings</Text>
      <Card className="p-4 rounded-xl shadow mb-4">
        <Text className="mb-2">Concert Keyword</Text>
        <Input className="mb-4" value={keyword} onChangeText={setKeyword} placeholder="e.g. 张学友" />
        <Text className="mb-2">City</Text>
        <Select
          className="mb-4"
          selectedValue={city}
          onValueChange={(val) => setCity(val)}
          options={[{ label: '上海', value: '上海' }, { label: '北京', value: '北京' }]}
        />
        <View className="flex-row items-center mb-4">
          <Toggle value={listenReturn} onValueChange={setListenReturn} />
          <Text className="ml-2">Listen for 回流票</Text>
        </View>
        <Text className="mb-2">Frequency (seconds)</Text>
        <Input keyboardType="numeric" value={interval} onChangeText={setInterval} className="mb-4" />
        <Button onPress={startListening} className="rounded-xl">Start Listening</Button>
      </Card>
    </View>
  );
}
