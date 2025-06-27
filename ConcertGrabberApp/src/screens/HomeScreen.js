import React from 'react';
import { View, Text } from 'react-native';
import { Button, Card } from 'shadcn-ui';
import { useNavigation } from '@react-navigation/native';

export default function HomeScreen() {
  const navigation = useNavigation();

  return (
    <View className="flex-1 bg-gray-100 p-4">
      <Text className="text-2xl font-bold mb-4">Auto Concert Grabber</Text>
      <Card className="p-4 rounded-xl shadow mb-4">
        <Text className="text-lg">Monitoring for 张学友 in 上海</Text>
        <Text className="text-sm text-gray-500 mt-1">Started: 2023-01-01 10:00</Text>
        <Text className="text-sm text-gray-500 mt-1">Status: Not yet triggered</Text>
      </Card>
      <Button className="rounded-xl" onPress={() => navigation.navigate('Settings')}>
        Go to Settings
      </Button>
    </View>
  );
}
